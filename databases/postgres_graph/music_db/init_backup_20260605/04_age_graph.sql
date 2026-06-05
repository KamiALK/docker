-- ============================================================
-- 04_age_graph.sql
-- ============================================================

LOAD 'age';
SET search_path = ag_catalog, "$user", public;

SELECT create_vlabel('music_graph', 'Song');
SELECT create_vlabel('music_graph', 'Artist');
SELECT create_vlabel('music_graph', 'Genre');
SELECT create_vlabel('music_graph', 'User');

SELECT create_elabel('music_graph', 'SOUNDS_LIKE');
SELECT create_elabel('music_graph', 'BY_ARTIST');
SELECT create_elabel('music_graph', 'IN_GENRE');
SELECT create_elabel('music_graph', 'REQUESTED');
SELECT create_elabel('music_graph', 'LIKED');
SELECT create_elabel('music_graph', 'SIMILAR_TASTE');
