-- CASA EN ORDEN 3.8.3
-- Mostrar propietarios y administradores a los integrantes de SU casa.
-- No elimina tablas ni cambia los permisos de escritura.
-- Ejecutar una sola vez en el SQL Editor del proyecto Supabase.
BEGIN;

CREATE OR REPLACE FUNCTION public.household_admin_contacts(p_household uuid)
RETURNS TABLE(email text, role text)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = '' AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'AUTH_REQUIRED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.memberships m
    WHERE m.household_id = p_household
      AND m.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'HOUSE_ACCESS_DENIED';
  END IF;
  RETURN QUERY
  SELECT u.email::text, m.role::text
  FROM public.memberships m
  JOIN auth.users u ON u.id = m.user_id
  WHERE m.household_id = p_household
    AND m.role IN ('owner','admin')
  ORDER BY CASE WHEN m.role = 'owner' THEN 0 ELSE 1 END, lower(u.email);
END;
$$;

REVOKE ALL ON FUNCTION public.household_admin_contacts(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.household_admin_contacts(uuid) TO authenticated;
COMMIT;

-- Comprobación opcional: debe aparecer la función, nunca correos personales.
SELECT proname AS funcion, prosecdef AS seguridad_definidor
FROM pg_proc
WHERE oid = to_regprocedure('public.household_admin_contacts(uuid)');
