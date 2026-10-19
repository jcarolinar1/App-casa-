-- Casa en Orden 3.9: nombres públicos únicamente dentro del hogar autorizado.
-- Ejecutar después de supabase_setup.sql / instalación 3.7.
-- No modifica ni borra los permisos existentes.
BEGIN;

CREATE TABLE IF NOT EXISTS public.household_member_names (
 household_id uuid NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
 user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 display_name text NOT NULL CHECK (char_length(btrim(display_name)) BETWEEN 1 AND 65),
 updated_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY (household_id, user_id)
);
ALTER TABLE public.household_member_names ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.household_member_names FROM public, anon, authenticated;

-- La app lee y escribe exclusivamente mediante funciones protegidas.
CREATE OR REPLACE FUNCTION public.household_member_labels(p_household uuid)
RETURNS TABLE(email text, role text, display_name text)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = '' AS $$
BEGIN
 IF auth.uid() IS NULL OR NOT EXISTS (
  SELECT 1 FROM public.memberships m
  WHERE m.household_id = p_household AND m.user_id = auth.uid()
 ) THEN RAISE EXCEPTION 'HOUSE_ACCESS_DENIED'; END IF;
 RETURN QUERY
 SELECT u.email::text, m.role::text, n.display_name::text
 FROM public.memberships m
 JOIN auth.users u ON u.id = m.user_id
 LEFT JOIN public.household_member_names n
  ON n.household_id=m.household_id AND n.user_id=m.user_id
 WHERE m.household_id = p_household
 ORDER BY CASE WHEN m.role='owner' THEN 0 WHEN m.role='admin' THEN 1 ELSE 2 END,
 lower(coalesce(n.display_name,u.email));
END;$$;
REVOKE ALL ON FUNCTION public.household_member_labels(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.household_member_labels(uuid) TO authenticated;

CREATE OR REPLACE FUNCTION public.set_member_display_name(
 p_household uuid, p_email text, p_name text)
RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE target_id uuid;
BEGIN
 IF auth.uid() IS NULL OR NOT EXISTS (
  SELECT 1 FROM public.memberships m
  WHERE m.household_id=p_household AND m.user_id=auth.uid()
  AND m.role IN ('owner','admin')
 ) THEN RAISE EXCEPTION 'ADMIN_REQUIRED'; END IF;
 IF p_name IS NULL OR char_length(btrim(p_name)) NOT BETWEEN 1 AND 65
 THEN RAISE EXCEPTION 'INVALID_NAME'; END IF;
 SELECT m.user_id INTO target_id
 FROM public.memberships m
 JOIN auth.users u ON u.id=m.user_id
 WHERE m.household_id=p_household AND lower(u.email)=lower(trim(p_email))
 LIMIT 1;
 IF target_id IS NULL THEN RAISE EXCEPTION 'MEMBER_NOT_FOUND'; END IF;
 INSERT INTO public.household_member_names(household_id,user_id,display_name,updated_at)
 VALUES(p_household,target_id,btrim(p_name),now())
 ON CONFLICT (household_id,user_id)
 DO UPDATE SET display_name=EXCLUDED.display_name,updated_at=now();
 RETURN true;
END;$$;
REVOKE ALL ON FUNCTION public.set_member_display_name(uuid,text,text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_member_display_name(uuid,text,text) TO authenticated;
COMMIT;

-- Prueba segura, solo confirma las funciones y la protección de la tabla.
SELECT 'Nombres de integrantes instalados' AS resultado,
 (SELECT relrowsecurity FROM pg_class WHERE oid=to_regclass('public.household_member_names')) AS rls_activo;
