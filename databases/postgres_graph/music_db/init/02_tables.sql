-- ============================================================
-- 02_tables.sql
-- Creación de todas las tablas relacionales
-- App Musical para Bar
-- ============================================================

-- Extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ────────────────────────────────────────────
-- USUARIOS
-- ────────────────────────────────────────────
CREATE TABLE users (
    id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    username         VARCHAR(50) NOT NULL,
    email            VARCHAR(100),
    role             VARCHAR(20) NOT NULL DEFAULT 'client'
                                 CHECK (role IN ('client', 'admin')),
    is_anonymous     BOOLEAN     NOT NULL DEFAULT false,
    location_enabled BOOLEAN     NOT NULL DEFAULT false,
    is_active        BOOLEAN     NOT NULL DEFAULT true,
    created_at       TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMP   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE users IS 'Usuarios del sistema: clientes del bar y administradores';
COMMENT ON COLUMN users.role IS 'client = cliente del bar | admin = personal del bar';
COMMENT ON COLUMN users.is_anonymous IS 'Si true, otros usuarios no ven su nombre';

-- ────────────────────────────────────────────
-- CRÉDITOS DE USUARIO
-- ────────────────────────────────────────────
CREATE TABLE user_credits (
    id                UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id           UUID      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    credits_available INT       NOT NULL DEFAULT 0 CHECK (credits_available >= 0),
    credits_used      INT       NOT NULL DEFAULT 0 CHECK (credits_used >= 0),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_credits UNIQUE (user_id)
);

COMMENT ON TABLE user_credits IS 'Saldo de créditos actual de cada cliente';

-- ────────────────────────────────────────────
-- CÓDIGOS DE ACCESO
-- ────────────────────────────────────────────
CREATE TABLE access_codes (
    id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    code         VARCHAR(20) NOT NULL UNIQUE,
    admin_id     UUID        NOT NULL REFERENCES users(id),
    user_id      UUID        REFERENCES users(id),
    credits      INT         NOT NULL DEFAULT 1 CHECK (credits > 0),
    used         BOOLEAN     NOT NULL DEFAULT false,
    expires_at   TIMESTAMP,
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW(),
    used_at      TIMESTAMP
);

COMMENT ON TABLE access_codes IS 'Códigos de un solo uso generados por el admin para habilitar clientes';
COMMENT ON COLUMN access_codes.user_id IS 'Se asigna cuando el cliente canjea el código';

-- ────────────────────────────────────────────
-- CANCIONES
-- ────────────────────────────────────────────
CREATE TABLE songs (
    id          UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    title       VARCHAR(200)  NOT NULL,
    artist      VARCHAR(200)  NOT NULL,
    genre       VARCHAR(50),
    bpm         INT           CHECK (bpm > 0 AND bpm < 300),
    energy      DECIMAL(3,2)  CHECK (energy >= 0 AND energy <= 1),
    year        INT           CHECK (year > 1900),
    youtube_id  VARCHAR(20)   NOT NULL UNIQUE,
    is_blocked  BOOLEAN       NOT NULL DEFAULT false,
    blocked_by  UUID          REFERENCES users(id),
    blocked_at  TIMESTAMP,
    created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE songs IS 'Catálogo de canciones disponibles en la app';
COMMENT ON COLUMN songs.energy IS 'Valor entre 0.0 y 1.0 que representa la energía de la canción';
COMMENT ON COLUMN songs.youtube_id IS 'ID del video en YouTube (ej: dQw4w9WgXcQ)';
COMMENT ON COLUMN songs.is_blocked IS 'Si true, el admin la bloqueó y no puede ser solicitada';

-- ────────────────────────────────────────────
-- SOLICITUDES DE CANCIONES
-- ────────────────────────────────────────────
CREATE TABLE song_requests (
    id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id      UUID        NOT NULL REFERENCES users(id),
    song_id      UUID        NOT NULL REFERENCES songs(id),
    likes_count  INT         NOT NULL DEFAULT 0,
    status       VARCHAR(20) NOT NULL DEFAULT 'pending'
                             CHECK (status IN ('pending', 'queued', 'playing', 'played', 'skipped')),
    requested_at TIMESTAMP   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE song_requests IS 'Cada solicitud de canción hecha por un cliente';
COMMENT ON COLUMN song_requests.status IS 'pending=recibida | queued=en cola | playing=sonando | played=reproducida | skipped=saltada';

-- ────────────────────────────────────────────
-- LIKES
-- ────────────────────────────────────────────
CREATE TABLE likes (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID        NOT NULL REFERENCES users(id),
    song_id     UUID        REFERENCES songs(id),
    request_id  UUID        REFERENCES song_requests(id),
    like_type   VARCHAR(20) NOT NULL CHECK (like_type IN ('song', 'recommender')),
    created_at  TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_like_song        UNIQUE (user_id, song_id, like_type),
    CONSTRAINT chk_like_target     CHECK (
        (like_type = 'song'        AND song_id    IS NOT NULL) OR
        (like_type = 'recommender' AND request_id IS NOT NULL)
    )
);

COMMENT ON TABLE likes IS 'Likes a canciones y a usuarios que recomendaron canciones';
COMMENT ON COLUMN likes.like_type IS 'song = like a la canción | recommender = like a quien la pidió';

-- ────────────────────────────────────────────
-- COLA DE REPRODUCCIÓN
-- ────────────────────────────────────────────
CREATE TABLE play_queue (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    song_id       UUID        NOT NULL REFERENCES songs(id),
    request_id    UUID        REFERENCES song_requests(id),
    position      INT         NOT NULL,
    is_transition BOOLEAN     NOT NULL DEFAULT false,
    status        VARCHAR(20) NOT NULL DEFAULT 'waiting'
                              CHECK (status IN ('waiting', 'playing', 'played', 'removed')),
    added_at      TIMESTAMP   NOT NULL DEFAULT NOW(),
    played_at     TIMESTAMP,
    CONSTRAINT uq_queue_position UNIQUE (position, status)
        DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE play_queue IS 'Cola de reproducción en tiempo real';
COMMENT ON COLUMN play_queue.is_transition IS 'Si true, fue insertada automáticamente por el algoritmo como transición';
COMMENT ON COLUMN play_queue.position IS 'Orden de reproducción en la cola';

-- ────────────────────────────────────────────
-- HISTORIAL DE REPRODUCCIÓN
-- ────────────────────────────────────────────
CREATE TABLE play_history (
    id               UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    song_id          UUID      NOT NULL REFERENCES songs(id),
    request_id       UUID      REFERENCES song_requests(id),
    played_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    duration_seconds INT,
    was_skipped      BOOLEAN   NOT NULL DEFAULT false
);

COMMENT ON TABLE play_history IS 'Historial completo de canciones reproducidas — alimenta el algoritmo del grafo';

-- ────────────────────────────────────────────
-- PESOS DEL GRAFO (tabla puente con PostgreSQL)
-- ────────────────────────────────────────────
CREATE TABLE song_graph_weights (
    id           UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    song_a_id    UUID          NOT NULL REFERENCES songs(id),
    song_b_id    UUID          NOT NULL REFERENCES songs(id),
    weight       DECIMAL(5,4)  NOT NULL DEFAULT 0.5
                               CHECK (weight >= 0 AND weight <= 1),
    relation_type VARCHAR(30)  NOT NULL CHECK (relation_type IN (
                               'similar_sound',
                               'same_artist',
                               'same_genre',
                               'user_behavior'
                 )),
    updated_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_song_pair UNIQUE (song_a_id, song_b_id, relation_type),
    CONSTRAINT chk_no_self_loop CHECK (song_a_id != song_b_id)
);

COMMENT ON TABLE song_graph_weights IS 'Pesos de las aristas del grafo musical — sincronizados con Apache AGE';
COMMENT ON COLUMN song_graph_weights.weight IS 'Valor entre 0 y 1. Más alto = más relacionadas las canciones';
COMMENT ON COLUMN song_graph_weights.relation_type IS 'Tipo de relación entre las canciones';


-- ────────────────────────────────────────────
-- PERMISOS PARA music_user
-- ────────────────────────────────────────────
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO music_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO music_user;
