-- CASA EN ORDEN 3.8.2
-- Desvinculación segura de integrantes por casa. Ejecutar UNA sola vez en Supabase SQL Editor.
-- No borra casas, movimientos, documentos ni usuarios de Supabase Auth.
-- La revocación surte efecto en el servidor inmediatamente; una copia descargada en
-- un teléfono desconectado no puede borrarse a distancia.
BEGIN;
DO $$ BEGIN
 IF to_regclass('public.households') IS NULL OR to_regclass('public.memberships') IS NULL
   OR to_regclass('public.invitations') IS NULL THEN
   RAISE EXCEPTION 'FALTAN_TABLAS: instala primero el SQL de Casa en Orden 3.7';
 END IF;
END $$;

CREATE OR REPLACE FUNCTION public.remove_household_member(p_household uuid, p_email text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE actor_role text; target_role text; target_user uuid; target_email text;
BEGIN
 IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
 target_email:=lower(btrim(coalesce(p_email,'')));
 IF target_email='' THEN RAISE EXCEPTION 'INVALID_EMAIL'; END IF;
 SELECT m.role INTO actor_role FROM public.memberships m
 WHERE m.household_id=p_household AND m.user_id=(SELECT auth.uid());
 IF actor_role IS NULL OR actor_role NOT IN ('owner','admin') THEN
  RAISE EXCEPTION 'ADMIN_REQUIRED';
 END IF;
 SELECT u.id INTO target_user FROM auth.users u WHERE lower(u.email)=target_email;
 IF target_user IS NULL THEN RAISE EXCEPTION 'ACCOUNT_NOT_FOUND'; END IF;
 SELECT m.role INTO target_role FROM public.memberships m
 WHERE m.household_id=p_household AND m.user_id=target_user FOR UPDATE;
 IF target_role IS NULL THEN RAISE EXCEPTION 'NOT_MEMBER_OF_THIS_HOUSE'; END IF;
 IF target_role='owner' THEN RAISE EXCEPTION 'CANNOT_REMOVE_OWNER'; END IF;
 IF target_role='admin' AND actor_role<>'owner' THEN
  RAISE EXCEPTION 'OWNER_REQUIRED_TO_REMOVE_ADMIN';
 END IF;
 DELETE FROM public.memberships m WHERE m.household_id=p_household AND m.user_id=target_user;
 -- Borrar invitaciones previas evita reaceptar una invitación antigua del mismo hogar.
 DELETE FROM public.invitations i WHERE i.household_id=p_household AND lower(i.email)=target_email;
 RETURN TRUE;
END;
$$;
REVOKE ALL ON FUNCTION public.remove_household_member(uuid,text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.remove_household_member(uuid,text) TO authenticated;
COMMIT;

-- Solo lectura: confirmar que se creó la función.
SELECT p.proname AS funcion, n.nspname AS esquema
FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
WHERE n.nspname='public' AND p.proname='remove_household_member';
