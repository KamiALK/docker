-- ============================================================
-- 02_tables.sql  —  Schema público + función create_tenant_schema
-- Generado desde schema_dump real 2026-06-05
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.platform_admins (
    id            UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    username      VARCHAR(50)   NOT NULL UNIQUE,
    email         VARCHAR(100)  NOT NULL UNIQUE,
    password_hash VARCHAR(200)  NOT NULL,
    is_active     BOOLEAN       NOT NULL DEFAULT true,
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.tenants (
    id                     UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    name                   VARCHAR(100) NOT NULL,
    schema                 VARCHAR(100) NOT NULL UNIQUE,
    is_active              BOOLEAN      NOT NULL DEFAULT true,
    created_at             TIMESTAMP    NOT NULL DEFAULT NOW(),
    plan                   VARCHAR(20)  NOT NULL DEFAULT 'free',
    plan_expires_at        TIMESTAMPTZ,
    roulette_sessions_used INT          NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.users (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    username      VARCHAR(50) NOT NULL,
    password_hash VARCHAR(200),
    role          VARCHAR(20) NOT NULL,
    tenant_id     UUID        NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    is_anonymous  BOOLEAN     NOT NULL DEFAULT false,
    is_active     BOOLEAN     NOT NULL DEFAULT true,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.user_profiles (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    nombres           VARCHAR(100),
    edad              INT,
    correo            VARCHAR(100),
    cancion_favorita  VARCHAR(200),
    animal_espiritual VARCHAR(50),
    generos_favoritos TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.artists (
    id         UUID         PRIMARY KEY,
    name       VARCHAR(200) NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL
);

CREATE TABLE IF NOT EXISTS public.genres (
    id         UUID        PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS public.songs (
    id               UUID         PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    artist_id        UUID         NOT NULL REFERENCES public.artists(id) ON DELETE CASCADE,
    genre_id         UUID         NOT NULL REFERENCES public.genres(id)  ON DELETE CASCADE,
    bpm              INT,
    energy           NUMERIC(3,2),
    year             INT,
    youtube_id       VARCHAR(20)  NOT NULL,
    mood             VARCHAR(20)  NOT NULL,
    mood_override    BOOLEAN      NOT NULL,
    is_active        BOOLEAN      NOT NULL,
    created_at       TIMESTAMPTZ  NOT NULL,
    updated_at       TIMESTAMPTZ  NOT NULL,
    valence          NUMERIC,
    danceability     NUMERIC,
    acousticness     NUMERIC,
    speechiness      NUMERIC,
    instrumentalness NUMERIC,
    liveness         NUMERIC,
    loudness         NUMERIC,
    musical_key      TEXT,
    time_signature   TEXT,
    spotify_id       TEXT
);

CREATE TABLE IF NOT EXISTS public.night_sessions (
    id                                     UUID        PRIMARY KEY,
    tenant_id                              UUID        NOT NULL,
    opened_at                              TIMESTAMPTZ NOT NULL,
    closed_at                              TIMESTAMPTZ,
    operation_mode                         TEXT        NOT NULL DEFAULT 'Playlist',
    hero_villain_mode                      TEXT        NOT NULL DEFAULT 'Hero',
    transition_temp                        TEXT        NOT NULL DEFAULT 'None',
    transition_temp_config_custom_song_ids TEXT        NOT NULL DEFAULT '',
    transition_temp_config_mode            TEXT        NOT NULL DEFAULT 'None',
    transition_temp_config_slope_direction INT         NOT NULL DEFAULT 0,
    transition_temp_config_source          TEXT        NOT NULL DEFAULT 'A',
    transition_temp_config_steps           INT         NOT NULL DEFAULT 0,
    transition_temp_config_recs            INT         NOT NULL DEFAULT 0,
    transition_temp_config_grafo           INT         NOT NULL DEFAULT 0,
    transition_temp_config_bootstrap       INT         NOT NULL DEFAULT 0,
    excluded_genre_ids                     UUID[]      NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS public.session_users (
    id               UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    night_session_id UUID      NOT NULL REFERENCES public.night_sessions(id) ON DELETE CASCADE,
    user_id          UUID      NOT NULL,
    joined_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    left_at          TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.song_requests (
    id               UUID        PRIMARY KEY,
    night_session_id UUID        NOT NULL REFERENCES public.night_sessions(id) ON DELETE CASCADE,
    user_id          UUID        NOT NULL,
    song_id          UUID        NOT NULL REFERENCES public.songs(id) ON DELETE CASCADE,
    likes_count      INT         NOT NULL,
    status           TEXT        NOT NULL,
    requested_at     TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS public.play_histories (
    id               UUID        PRIMARY KEY,
    song_id          UUID        NOT NULL REFERENCES public.songs(id) ON DELETE RESTRICT,
    request_id       UUID,
    played_at        TIMESTAMPTZ NOT NULL,
    duration_seconds INT,
    was_skipped      BOOLEAN     NOT NULL,
    night_session_id UUID        NOT NULL REFERENCES public.night_sessions(id) ON DELETE CASCADE,
    previous_song_id UUID        REFERENCES public.songs(id),
    interaction_type INT         NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.song_recommendations (
    id             UUID         PRIMARY KEY,
    source_song_id UUID         NOT NULL REFERENCES public.songs(id) ON DELETE CASCADE,
    spotify_id     VARCHAR(50)  NOT NULL,
    name           VARCHAR(300) NOT NULL,
    bpm            INT,
    energy         NUMERIC(3,2),
    valence        NUMERIC,
    danceability   NUMERIC,
    created_at     TIMESTAMPTZ  NOT NULL,
    used_at        TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.tenant_settings (
    id                     UUID        PRIMARY KEY,
    auto_transition        BOOLEAN     NOT NULL,
    transition_on_empty    BOOLEAN     NOT NULL,
    transition_count       INT         NOT NULL,
    transition_mode        TEXT        NOT NULL,
    queue_visible_count    INT         NOT NULL,
    max_song_repeat_night  INT         NOT NULL,
    updated_at             TIMESTAMPTZ NOT NULL,
    default_operation_mode TEXT        NOT NULL,
    graph_memory_mode      TEXT        NOT NULL,
    youtube_playlist_url   TEXT,
    tenant_id              UUID        NOT NULL,
    initial_credits        INT         NOT NULL DEFAULT 0,
    auto_assign_credits    BOOLEAN     NOT NULL DEFAULT false,
    queue_mix_percent      INT         NOT NULL DEFAULT 50,
    auto_approve           BOOLEAN     NOT NULL DEFAULT false
);

CREATE OR REPLACE FUNCTION public.create_tenant_schema(tenant_id uuid) RETURNS void
    LANGUAGE plpgsql AS $func$
DECLARE
    s TEXT := 'tenant_' || replace(tenant_id::text, '-', '');
BEGIN
    EXECUTE 'CREATE SCHEMA IF NOT EXISTS ' || quote_ident(s);
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.users (
        id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        username         VARCHAR(50) NOT NULL,
        email            VARCHAR(100),
        role             VARCHAR(20) NOT NULL DEFAULT ''client'' CHECK (role IN (''client'', ''admin'')),
        is_anonymous     BOOLEAN     NOT NULL DEFAULT false,
        location_enabled BOOLEAN     NOT NULL DEFAULT false,
        is_active        BOOLEAN     NOT NULL DEFAULT true,
        password_hash    VARCHAR(200),
        created_at       TIMESTAMP   NOT NULL DEFAULT NOW(),
        updated_at       TIMESTAMP   NOT NULL DEFAULT NOW()
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.user_credits (
        id                UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id           UUID      NOT NULL REFERENCES ' || quote_ident(s) || '.users(id) ON DELETE CASCADE,
        credits_available INT       NOT NULL DEFAULT 0 CHECK (credits_available >= 0),
        credits_used      INT       NOT NULL DEFAULT 0 CHECK (credits_used >= 0),
        updated_at        TIMESTAMP NOT NULL DEFAULT NOW(),
        CONSTRAINT ' || quote_ident('uq_' || s || '_user_credits') || ' UNIQUE (user_id)
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.access_codes (
        id         UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        code       VARCHAR(20) NOT NULL UNIQUE,
        admin_id   UUID        NOT NULL REFERENCES ' || quote_ident(s) || '.users(id),
        user_id    UUID        REFERENCES ' || quote_ident(s) || '.users(id),
        credits    INT         NOT NULL DEFAULT 1 CHECK (credits > 0),
        used       BOOLEAN     NOT NULL DEFAULT false,
        expires_at TIMESTAMP,
        created_at TIMESTAMP   NOT NULL DEFAULT NOW(),
        used_at    TIMESTAMP
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.tenant_songs (
        id         UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
        song_id    UUID      NOT NULL REFERENCES public.songs(id),
        is_enabled BOOLEAN   NOT NULL DEFAULT true,
        is_blocked BOOLEAN   NOT NULL DEFAULT false,
        blocked_by UUID      REFERENCES ' || quote_ident(s) || '.users(id),
        blocked_at TIMESTAMP,
        added_at   TIMESTAMP NOT NULL DEFAULT NOW(),
        CONSTRAINT ' || quote_ident('uq_' || s || '_song') || ' UNIQUE (song_id)
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.night_sessions (
        id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        opened_at         TIMESTAMP   NOT NULL DEFAULT NOW(),
        closed_at         TIMESTAMP,
        operation_mode    VARCHAR(20) NOT NULL DEFAULT ''bootstrap'' CHECK (operation_mode IN (''playlist'', ''bootstrap'', ''smart'', ''audience'')),
        hero_villain_mode VARCHAR(20) NOT NULL DEFAULT ''hero'' CHECK (hero_villain_mode IN (''hero'', ''villain''))
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.song_requests (
        id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id          UUID        NOT NULL REFERENCES ' || quote_ident(s) || '.users(id),
        song_id          UUID        NOT NULL REFERENCES public.songs(id),
        likes_count      INT         NOT NULL DEFAULT 0,
        status           VARCHAR(20) NOT NULL DEFAULT ''pending'' CHECK (status IN (''pending'', ''queued'', ''playing'', ''played'', ''skipped'')),
        requested_at     TIMESTAMP   NOT NULL DEFAULT NOW(),
        night_session_id UUID        NOT NULL DEFAULT ''00000000-0000-0000-0000-000000000000''::uuid
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.likes (
        id         UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id    UUID        NOT NULL REFERENCES ' || quote_ident(s) || '.users(id),
        song_id    UUID        REFERENCES public.songs(id),
        request_id UUID        REFERENCES ' || quote_ident(s) || '.song_requests(id),
        like_type  VARCHAR(20) NOT NULL CHECK (like_type IN (''song'', ''recommender'', ''dislike'')),
        created_at TIMESTAMP   NOT NULL DEFAULT NOW(),
        CONSTRAINT ' || quote_ident('uq_' || s || '_like_song') || ' UNIQUE (user_id, song_id, like_type)
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.play_queue (
        id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        song_id       UUID        NOT NULL REFERENCES public.songs(id),
        request_id    UUID        REFERENCES ' || quote_ident(s) || '.song_requests(id),
        position      INT         NOT NULL,
        is_transition BOOLEAN     NOT NULL DEFAULT false,
        status        VARCHAR(20) NOT NULL DEFAULT ''waiting'' CHECK (status IN (''waiting'', ''playing'', ''played'', ''removed'')),
        added_at      TIMESTAMP   NOT NULL DEFAULT NOW(),
        played_at     TIMESTAMP,
        priority      INT         NOT NULL DEFAULT 3,
        source        VARCHAR(20) NOT NULL DEFAULT ''graph''
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.play_history (
        id               UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
        song_id          UUID      NOT NULL REFERENCES public.songs(id),
        request_id       UUID      REFERENCES ' || quote_ident(s) || '.song_requests(id),
        played_at        TIMESTAMP NOT NULL DEFAULT NOW(),
        duration_seconds INT,
        was_skipped      BOOLEAN   NOT NULL DEFAULT false
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.song_graph_weights (
        id            UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
        song_a_id     UUID         NOT NULL REFERENCES public.songs(id),
        song_b_id     UUID         NOT NULL REFERENCES public.songs(id),
        weight        DECIMAL(5,4) NOT NULL DEFAULT 0.5 CHECK (weight >= 0 AND weight <= 1),
        relation_type VARCHAR(30)  NOT NULL CHECK (relation_type IN (''similar_sound'', ''same_artist'', ''same_genre'', ''same_mood'', ''user_behavior'')),
        updated_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
        CONSTRAINT ' || quote_ident('uq_' || s || '_song_pair') || ' UNIQUE (song_a_id, song_b_id, relation_type),
        CONSTRAINT ' || quote_ident('chk_' || s || '_no_self_loop') || ' CHECK (song_a_id <> song_b_id)
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.tenant_settings (
        id                     UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
        auto_transition        BOOLEAN     NOT NULL DEFAULT true,
        transition_on_empty    BOOLEAN     NOT NULL DEFAULT true,
        transition_count       INT         NOT NULL DEFAULT 1 CHECK (transition_count IN (1, 2)),
        transition_mode        VARCHAR(30) NOT NULL DEFAULT ''mood'' CHECK (transition_mode IN (''mood'', ''genre'', ''bpm'', ''mixed'')),
        queue_visible_count    INT         NOT NULL DEFAULT 5,
        max_song_repeat_night  INT         NOT NULL DEFAULT 1,
        updated_at             TIMESTAMP   NOT NULL DEFAULT NOW(),
        auto_assign_credits    BOOLEAN     NOT NULL DEFAULT false,
        initial_credits        INT         NOT NULL DEFAULT 0,
        queue_mix_percent      INT         NOT NULL DEFAULT 50,
        default_operation_mode INT         NOT NULL DEFAULT 0,
        graph_memory_mode      INT         NOT NULL DEFAULT 0,
        youtube_playlist_url   TEXT,
        tenant_id              UUID,
        auto_approve           BOOLEAN     NOT NULL DEFAULT false
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.tenant_youtube_credentials (
        id         UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
        api_key    VARCHAR(200) NOT NULL,
        client_id  VARCHAR(200),
        is_active  BOOLEAN      NOT NULL DEFAULT true,
        created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
    )';
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || quote_ident(s) || '.session_users (
        id               UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
        night_session_id UUID      NOT NULL REFERENCES ' || quote_ident(s) || '.night_sessions(id) ON DELETE CASCADE,
        user_id          UUID      NOT NULL REFERENCES ' || quote_ident(s) || '.users(id) ON DELETE CASCADE,
        joined_at        TIMESTAMP NOT NULL DEFAULT NOW(),
        left_at          TIMESTAMP,
        CONSTRAINT ' || quote_ident('uq_' || s || '_session_user') || ' UNIQUE (night_session_id, user_id)
    )';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.users(role)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.users(is_active)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.tenant_songs(song_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.tenant_songs(is_blocked)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_requests(user_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_requests(song_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_requests(status)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_requests(requested_at DESC)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.likes(user_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.likes(song_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.play_queue(status)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.play_queue(position)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.play_history(song_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.play_history(played_at DESC)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_graph_weights(song_a_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_graph_weights(song_b_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_graph_weights(relation_type)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.song_graph_weights(weight DESC)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.night_sessions(opened_at DESC)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.night_sessions(closed_at)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.session_users(night_session_id)';
    EXECUTE 'CREATE INDEX IF NOT EXISTS ON ' || quote_ident(s) || '.session_users(left_at)';
END;
$func$;
