-- CASA EN ORDEN 3.5: DOS CASAS Y ADMINISTRADORES POR CASA.
-- PRERREQUISITO: ya ejecutaste supabase_setup.sql de Casa en Orden.
-- Este archivo actualiza los permisos existentes; NO borra movimientos ni hogares.
-- Ejecutar UNA VEZ en SQL Editor como propietario del proyecto Supabase.
BEGIN;
DO $$ BEGIN
  IF to_regclass('public.memberships') IS NULL OR to_regclass('public.households') IS NULL THEN
    RAISE EXCEPTION 'Primero ejecuta supabase_setup.sql de Casa en Orden.';
  END IF;
END $$;

-- El administrador puede editar el contenido y gestionar invitaciones de SU casa.
ALTER TABLE public.memberships DROP CONSTRAINT IF EXISTS memberships_role_check;
ALTER TABLE public.memberships ADD CONSTRAINT memberships_role_check
  CHECK (role IN ('owner','admin','editor','viewer'));

CREATE OR REPLACE FUNCTION public.can_edit(h uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = '' AS $$
 SELECT EXISTS (
   SELECT 1 FROM public.memberships m
   WHERE m.household_id = h AND m.user_id = auth.uid()
     AND m.role IN ('owner','admin','editor')
 );
$$;
REVOKE ALL ON FUNCTION public.can_edit(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_edit(uuid) TO authenticated;

-- Permite invitar tanto a propietario como a administrador de ESA casa.
CREATE OR REPLACE FUNCTION public.invite_member(p_household uuid, p_email text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE em text;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
 IF NOT EXISTS(
   SELECT 1 FROM public.memberships m WHERE m.household_id=p_household
    AND m.user_id=auth.uid() AND m.role IN ('owner','admin')
 ) THEN RAISE EXCEPTION 'ADMIN_REQUIRED'; END IF;
 em=lower(trim(p_email));
 IF em IS NULL OR em !~ '^[^@ ]+@[^@ ]+\.[^@ ]+$' THEN RAISE EXCEPTION 'INVALID_EMAIL'; END IF;
 INSERT INTO public.invitations(household_id,email,invited_by)
 VALUES(p_household,em,auth.uid())
 ON CONFLICT(household_id,email) DO UPDATE SET
 accepted_at=NULL,created_at=now(),invited_by=excluded.invited_by;
 RETURN TRUE;
END; $$;
REVOKE ALL ON FUNCTION public.invite_member(uuid,text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.invite_member(uuid,text) TO authenticated;

-- Solo el propietario asigna o retira administradores. No se puede degradar al dueño.
-- Administradores sí pueden gestionar permisos editor/lector de otras personas no administradoras.
CREATE OR REPLACE FUNCTION public.set_member_role(p_household uuid,p_email text,p_role text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE actor_role text; target_role text; recipient uuid;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
 IF p_role NOT IN ('admin','editor','viewer') THEN RAISE EXCEPTION 'INVALID_ROLE'; END IF;
 SELECT m.role INTO actor_role FROM public.memberships m
 WHERE m.household_id=p_household AND m.user_id=auth.uid();
 IF actor_role NOT IN ('owner','admin') OR actor_role IS NULL THEN
   RAISE EXCEPTION 'ADMIN_REQUIRED'; END IF;
 IF p_role='admin' AND actor_role<>'owner' THEN
   RAISE EXCEPTION 'OWNER_REQUIRED_TO_ASSIGN_ADMIN'; END IF;
 SELECT u.id INTO recipient FROM auth.users u
 WHERE lower(u.email)=lower(trim(p_email)) AND u.email_confirmed_at IS NOT NULL;
 IF recipient IS NULL THEN RAISE EXCEPTION 'ACCOUNT_NOT_FOUND'; END IF;
 SELECT m.role INTO target_role FROM public.memberships m
 WHERE m.household_id=p_household AND m.user_id=recipient FOR UPDATE;
 IF target_role IS NULL THEN RAISE EXCEPTION 'NOT_MEMBER_OF_THIS_HOUSE'; END IF;
 IF target_role='owner' OR (target_role='admin' AND actor_role<>'owner') THEN
   RAISE EXCEPTION 'CANNOT_CHANGE_THIS_MEMBER'; END IF;
 UPDATE public.memberships SET role=p_role
 WHERE household_id=p_household AND user_id=recipient;
 RETURN TRUE;
END; $$;
REVOKE ALL ON FUNCTION public.set_member_role(uuid,text,text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_member_role(uuid,text,text) TO authenticated;

-- Consultar lista de integrantes solo si administra la casa seleccionada.
CREATE OR REPLACE FUNCTION public.household_members(p_household uuid)
RETURNS TABLE(email text, role text)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = '' AS $$
BEGIN
 IF NOT EXISTS (
   SELECT 1 FROM public.memberships x
   WHERE x.household_id=p_household AND x.user_id=auth.uid()
   AND x.role IN ('owner','admin')
 ) THEN RAISE EXCEPTION 'ADMIN_REQUIRED'; END IF;
 RETURN QUERY
 SELECT u.email::text,m.role::text FROM public.memberships m
 JOIN auth.users u ON u.id=m.user_id
 WHERE m.household_id=p_household ORDER BY m.joined_at;
END; $$;
REVOKE ALL ON FUNCTION public.household_members(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.household_members(uuid) TO authenticated;
COMMIT;
