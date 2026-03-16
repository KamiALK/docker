-- ============================================================
-- 04_age_graph.sql
-- Configuración del grafo musical en Apache AGE
-- Etiquetas de nodos y aristas
-- ============================================================

LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- ────────────────────────────────────────────
-- CREAR ETIQUETAS DE VÉRTICES (nodos)
-- ────────────────────────────────────────────

-- Nodo: Canción
SELECT create_vlabel('music_graph', 'Song');

-- Nodo: Artista
SELECT create_vlabel('music_graph', 'Artist');

-- Nodo: Género
SELECT create_vlabel('music_graph', 'Genre');

-- Nodo: Usuario
SELECT create_vlabel('music_graph', 'User');

-- ────────────────────────────────────────────
-- CREAR ETIQUETAS DE ARISTAS (relaciones)
-- ────────────────────────────────────────────

-- Canción → Canción: similitud de sonido
SELECT create_elabel('music_graph', 'SOUNDS_LIKE');

-- Canción → Artista: pertenece a
SELECT create_elabel('music_graph', 'BY_ARTIST');

-- Canción → Género: pertenece a
SELECT create_elabel('music_graph', 'IN_GENRE');

-- Usuario → Canción: solicitó
SELECT create_elabel('music_graph', 'REQUESTED');

-- Usuario → Canción: dio like
SELECT create_elabel('music_graph', 'LIKED');

-- Usuario → Usuario: gustos similares (calculado por el algoritmo)
SELECT create_elabel('music_graph', 'SIMILAR_TASTE');

-- ────────────────────────────────────────────
-- FUNCIÓN: Sincronizar canción de PostgreSQL al grafo
-- Se llama desde la app cuando se agrega una canción nueva
-- ────────────────────────────────────────────
CREATE OR REPLACE FUNCTION sync_song_to_graph(
    p_song_id   UUID,
    p_title     VARCHAR,
    p_artist    VARCHAR,
    p_genre     VARCHAR,
    p_bpm       INT,
    p_energy    DECIMAL
) RETURNS void AS $$
BEGIN
    LOAD 'age';
    SET search_path = ag_catalog, "$user", public;

    -- Crear nodo de la canción
    EXECUTE format(
        'SELECT * FROM cypher(''music_graph'', $$
            MERGE (s:Song {song_id: %L, title: %L, artist: %L, genre: %L, bpm: %s, energy: %s})
        $$) AS (result agtype)',
        p_song_id::text, p_title, p_artist, p_genre,
        COALESCE(p_bpm::text, 'null'),
        COALESCE(p_energy::text, 'null')
    );

    -- Crear o fusionar nodo de artista
    EXECUTE format(
        'SELECT * FROM cypher(''music_graph'', $$
            MERGE (a:Artist {name: %L})
        $$) AS (result agtype)',
        p_artist
    );

    -- Crear relación canción → artista
    EXECUTE format(
        'SELECT * FROM cypher(''music_graph'', $$
            MATCH (s:Song {song_id: %L}), (a:Artist {name: %L})
            MERGE (s)-[:BY_ARTIST]->(a)
        $$) AS (result agtype)',
        p_song_id::text, p_artist
    );

    -- Crear o fusionar nodo de género
    IF p_genre IS NOT NULL THEN
        EXECUTE format(
            'SELECT * FROM cypher(''music_graph'', $$
                MERGE (g:Genre {name: %L})
            $$) AS (result agtype)',
            p_genre
        );

        -- Crear relación canción → género
        EXECUTE format(
            'SELECT * FROM cypher(''music_graph'', $$
                MATCH (s:Song {song_id: %L}), (g:Genre {name: %L})
                MERGE (s)-[:IN_GENRE]->(g)
            $$) AS (result agtype)',
            p_song_id::text, p_genre
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ────────────────────────────────────────────
-- FUNCIÓN: Actualizar peso de relación entre canciones
-- Se llama desde el algoritmo cuando hay likes o solicitudes
-- ────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_song_similarity(
    p_song_a_id UUID,
    p_song_b_id UUID,
    p_weight    DECIMAL
) RETURNS void AS $$
BEGIN
    LOAD 'age';
    SET search_path = ag_catalog, "$user", public;

    -- Actualizar en tabla relacional
    INSERT INTO song_graph_weights (song_a_id, song_b_id, weight, relation_type)
    VALUES (p_song_a_id, p_song_b_id, p_weight, 'user_behavior')
    ON CONFLICT (song_a_id, song_b_id, relation_type)
    DO UPDATE SET weight = p_weight, updated_at = NOW();

    -- Actualizar o crear arista en el grafo AGE
    EXECUTE format(
        'SELECT * FROM cypher(''music_graph'', $$
            MATCH (a:Song {song_id: %L}), (b:Song {song_id: %L})
            MERGE (a)-[r:SOUNDS_LIKE]-(b)
            SET r.weight = %s, r.updated_at = timestamp()
        $$) AS (result agtype)',
        p_song_a_id::text, p_song_b_id::text, p_weight
    );
END;
$$ LANGUAGE plpgsql;

-- ────────────────────────────────────────────
-- FUNCIÓN: Obtener canciones recomendadas
-- Consulta Cypher — canciones más cercanas a una dada
-- ────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_recommended_songs(
    p_song_id   UUID,
    p_limit     INT DEFAULT 10
) RETURNS TABLE(song_id TEXT, weight FLOAT) AS $$
BEGIN
    LOAD 'age';
    SET search_path = ag_catalog, "$user", public;

    RETURN QUERY EXECUTE format(
        'SELECT result.song_id::text, result.weight::float
         FROM cypher(''music_graph'', $$
             MATCH (s:Song {song_id: %L})-[r:SOUNDS_LIKE]-(related:Song)
             WHERE r.weight IS NOT NULL
             RETURN related.song_id AS song_id, r.weight AS weight
             ORDER BY r.weight DESC
             LIMIT %s
         $$) AS result(song_id agtype, weight agtype)',
        p_song_id::text, p_limit
    );
END;
$$ LANGUAGE plpgsql;
