-- ============================================================
-- 05_seed.sql  —  Datos semilla
-- Idempotente: INSERT solo si no existe
-- ============================================================

-- SUPERADMIN
-- username: admin / password: admin123
INSERT INTO public.platform_admins (id, username, email, password_hash, is_active, created_at, updated_at)
VALUES (
    'c51be5d3-7de8-414a-b06a-29bceb4afc8a',
    'admin',
    'admin@music.com',
    '$2b$12$8jakarpTkAheD5k9rMG3UeUYsHnjOrTNrUDDhRkJ9da8Mh2IGenhG',
    true,
    NOW(),
    NOW()
)
ON CONFLICT (id) DO NOTHING;
