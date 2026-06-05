-- ============================================================
-- 04_age_graph.sql  —  Grafos AGE
-- Generado desde schema_dump real 2026-06-05
-- ============================================================
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

SELECT CASE
    WHEN NOT EXISTS (SELECT 1 FROM ag_catalog.ag_graph WHERE name = 'music_global')
    THEN create_graph('music_global')
END;

CREATE OR REPLACE FUNCTION public.create_tenant_graph(p_tenant_id uuid) RETURNS void
    LANGUAGE plpgsql AS $_$
DECLARE
    graph_name text := 'age_' || replace(p_tenant_id::text, '-', '');
BEGIN
    LOAD 'age';
    SET search_path = ag_catalog, "$user", public;
    PERFORM create_graph(graph_name);
END;
$_$;
