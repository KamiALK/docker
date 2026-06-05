-- ============================================================
-- 01_age_init.sql
-- ============================================================

-- 1. Instalar extensión
CREATE EXTENSION IF NOT EXISTS age;

-- 2. Cargar AGE y configurar search_path ANTES de crear el grafo
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- 3. Crear el grafo
SELECT create_graph('music_graph');

-- 4. CREAR USUARIO music_user
CREATE USER music_user WITH PASSWORD 'music1234';

-- 5. PERMISOS
GRANT ALL PRIVILEGES ON DATABASE music_app TO music_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO music_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO music_user;
GRANT USAGE ON SCHEMA ag_catalog TO music_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ag_catalog TO music_user;
GRANT ALL PRIVILEGES ON SCHEMA public TO music_user;

-- 6. CONFIGURACIÓN DEL USUARIO
ALTER USER music_user SET search_path = ag_catalog, "$user", public;

-- 7. TRASPASO DE PROPIEDAD
ALTER DATABASE music_app OWNER TO music_user;
