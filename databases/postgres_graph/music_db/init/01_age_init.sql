-- ============================================================
-- 01_age_init.sql
-- Configuración de Apache AGE para Producción
-- ============================================================

-- 1. Instalar extensión y cargar librerías
CREATE EXTENSION IF NOT EXISTS age;
LOAD 'age';

-- 2. Crear el grafo (esto debe hacerse antes de dar permisos)
SELECT create_graph('music_graph');

-- 3. PERMISOS PARA PRODUCCIÓN
-- Reemplaza 'music_user' si el nombre en tu docker-compose es distinto
GRANT USAGE ON SCHEMA ag_catalog TO music_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ag_catalog TO music_user;
GRANT ALL PRIVILEGES ON SCHEMA public TO music_user;

-- 4. CONFIGURACIÓN DEL USUARIO
-- Esto hace que el usuario siempre encuentre las funciones de AGE automáticamente
ALTER USER music_user SET search_path = ag_catalog, "$user", public;

-- 5. TRASPASO DE PROPIEDAD (Opcional pero recomendado)
-- Hace que music_user sea el dueño de la base de datos de la app
ALTER DATABASE music_app OWNER TO music_user;
