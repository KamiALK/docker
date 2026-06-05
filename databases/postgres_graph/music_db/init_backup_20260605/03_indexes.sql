-- ============================================================
-- 03_indexes.sql
-- Índices para optimizar las consultas más frecuentes
-- ============================================================

-- USERS
CREATE INDEX idx_users_role         ON users(role);
CREATE INDEX idx_users_is_active    ON users(is_active);

-- ACCESS CODES
CREATE INDEX idx_access_codes_admin    ON access_codes(admin_id);
CREATE INDEX idx_access_codes_user     ON access_codes(user_id);
CREATE INDEX idx_access_codes_used     ON access_codes(used);
CREATE INDEX idx_access_codes_code     ON access_codes(code);

-- SONGS
CREATE INDEX idx_songs_genre        ON songs(genre);
CREATE INDEX idx_songs_artist       ON songs(artist);
CREATE INDEX idx_songs_is_blocked   ON songs(is_blocked);
CREATE INDEX idx_songs_youtube_id   ON songs(youtube_id);

-- SONG REQUESTS
CREATE INDEX idx_requests_user      ON song_requests(user_id);
CREATE INDEX idx_requests_song      ON song_requests(song_id);
CREATE INDEX idx_requests_status    ON song_requests(status);
CREATE INDEX idx_requests_date      ON song_requests(requested_at DESC);

-- LIKES
CREATE INDEX idx_likes_user         ON likes(user_id);
CREATE INDEX idx_likes_song         ON likes(song_id);
CREATE INDEX idx_likes_request      ON likes(request_id);
CREATE INDEX idx_likes_type         ON likes(like_type);

-- PLAY QUEUE
CREATE INDEX idx_queue_status       ON play_queue(status);
CREATE INDEX idx_queue_position     ON play_queue(position);
CREATE INDEX idx_queue_song         ON play_queue(song_id);

-- PLAY HISTORY
CREATE INDEX idx_history_song       ON play_history(song_id);
CREATE INDEX idx_history_played_at  ON play_history(played_at DESC);

-- GRAPH WEIGHTS
CREATE INDEX idx_weights_song_a     ON song_graph_weights(song_a_id);
CREATE INDEX idx_weights_song_b     ON song_graph_weights(song_b_id);
CREATE INDEX idx_weights_type       ON song_graph_weights(relation_type);
CREATE INDEX idx_weights_weight     ON song_graph_weights(weight DESC);
