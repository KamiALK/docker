-- ============================================================
-- 03_indexes.sql  —  Índices del schema public
-- Generado desde schema_dump real 2026-06-05
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_users_tenant_id                 ON public.users(tenant_id);
CREATE INDEX IF NOT EXISTS idx_users_username                  ON public.users(username);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id           ON public.user_profiles(user_id);
CREATE INDEX IF NOT EXISTS ix_songs_artist_id                  ON public.songs(artist_id);
CREATE INDEX IF NOT EXISTS ix_songs_genre_id                   ON public.songs(genre_id);
CREATE INDEX IF NOT EXISTS ix_song_requests_song_id            ON public.song_requests(song_id);
CREATE INDEX IF NOT EXISTS ix_song_requests_night_session_id   ON public.song_requests(night_session_id);
CREATE INDEX IF NOT EXISTS ix_play_histories_song_id           ON public.play_histories(song_id);
CREATE INDEX IF NOT EXISTS ix_play_histories_night_session_id  ON public.play_histories(night_session_id);
CREATE INDEX IF NOT EXISTS ix_play_histories_previous_song_id  ON public.play_histories(previous_song_id);
CREATE INDEX IF NOT EXISTS ix_song_recommendations_source_song_id ON public.song_recommendations(source_song_id);
CREATE INDEX IF NOT EXISTS session_users_night_session_id_idx  ON public.session_users(night_session_id);
CREATE INDEX IF NOT EXISTS session_users_left_at_idx           ON public.session_users(left_at);
