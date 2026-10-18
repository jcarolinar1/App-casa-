-- CASA EN ORDEN 3.5 - EJECUTAR EN SQL EDITOR DE TU PROYECTO SUPABASE.
-- Usar un proyecto NUEVO; no ejecutes esto sobre tablas propias existentes.
-- No compartas la service_role ni la contraseña de base de datos.
create extension if not exists pgcrypto;

create table if not exists public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 90),
  snapshot jsonb not null default '{}'::jsonb,
  revision bigint not null default 0,
  updated_at timestamptz not null default now()
);
create table if not exists public.memberships (
  household_id uuid not null references public.households(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('owner','admin','editor','viewer')),
  joined_at timestamptz not null default now(),
  primary key(household_id,user_id)
);
create table if not exists public.invitations (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  email text not null,
  invited_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  accepted_at timestamptz,
  unique(household_id,email)
);

create or replace function public.is_member(h uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.memberships where household_id=h and user_id=auth.uid())
$$;
create or replace function public.can_edit(h uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.memberships where household_id=h and user_id=auth.uid() and role in ('owner','admin','editor'))
$$;
revoke all on function public.is_member(uuid) from public;
revoke all on function public.can_edit(uuid) from public;
grant execute on function public.is_member(uuid),public.can_edit(uuid) to authenticated;

alter table public.households enable row level security;
alter table public.memberships enable row level security;
alter table public.invitations enable row level security;
create policy "Read own household" on public.households for select to authenticated using (public.is_member(id));
create policy "Read own memberships" on public.memberships for select to authenticated using (public.is_member(household_id));
-- No direct household writes: all snapshot edits must pass the optimistic-lock RPC.
-- No direct invitation writes: only the owner can issue invitations through RPC.

create or replace function public.create_household(p_name text,p_snapshot jsonb)
returns uuid language plpgsql security definer set search_path=public as $$
declare h uuid;
begin
 if auth.uid() is null then raise exception 'AUTH_REQUIRED';end if;
 if char_length(trim(p_name)) not between 1 and 90 then raise exception 'INVALID_NAME';end if;
 insert into public.households(name,snapshot) values(trim(p_name),coalesce(p_snapshot,'{}'::jsonb)) returning id into h;
 insert into public.memberships(household_id,user_id,role) values(h,auth.uid(),'owner');
 return h;
end $$;

create or replace function public.my_households()
returns table(household_id uuid,name text,revision bigint,role text)
language sql stable security definer set search_path=public as $$
 select h.id,h.name,h.revision,m.role from public.households h
 join public.memberships m on m.household_id=h.id where m.user_id=auth.uid() order by h.updated_at desc
$$;

create or replace function public.invite_member(p_household uuid,p_email text)
returns boolean language plpgsql security definer set search_path=public as $$
declare em text;
begin
 if not exists(select 1 from public.memberships where household_id=p_household and user_id=auth.uid() and role in ('owner','admin')) then raise exception 'ADMIN_REQUIRED';end if;
 em=lower(trim(p_email));
 if em !~ '^[^@ ]+@[^@ ]+\.[^@ ]+$' then raise exception 'INVALID_EMAIL';end if;
 insert into public.invitations(household_id,email,invited_by) values(p_household,em,auth.uid())
 on conflict(household_id,email) do update set accepted_at=null,created_at=now(),invited_by=excluded.invited_by;
 return true;
end $$;

create or replace function public.accept_invitation()
returns uuid language plpgsql security definer set search_path=public as $$
declare em text; h uuid;
begin
 select lower(email) into em from auth.users where id=auth.uid() and email_confirmed_at is not null;
 if em is null then raise exception 'EMAIL_NOT_VERIFIED';end if;
 select household_id into h from public.invitations where email=em and accepted_at is null
 and created_at>now()-interval '30 days' order by created_at desc limit 1 for update;
 if h is null then raise exception 'NO_INVITATION';end if;
 insert into public.memberships(household_id,user_id,role) values(h,auth.uid(),'editor')
 on conflict(household_id,user_id) do nothing;
 update public.invitations set accepted_at=now() where household_id=h and email=em;
 return h;
end $$;

create or replace function public.push_snapshot(p_household uuid,p_snapshot jsonb,p_revision bigint)
returns jsonb language plpgsql security definer set search_path=public as $$
declare current_revision bigint;
begin
 if not public.can_edit(p_household) then raise exception 'NO_WRITE_ACCESS';end if;
 select revision into current_revision from public.households where id=p_household for update;
 if current_revision is null then raise exception 'HOUSEHOLD_NOT_FOUND';end if;
 if current_revision is distinct from p_revision then raise exception 'CONFLICT_SYNC';end if;
 update public.households set snapshot=p_snapshot,revision=revision+1,updated_at=now() where id=p_household;
 return jsonb_build_object('revision',current_revision+1);
end $$;

revoke all on function public.create_household(text,jsonb),public.my_households(),public.invite_member(uuid,text),public.accept_invitation(),public.push_snapshot(uuid,jsonb,bigint) from public;
grant execute on function public.create_household(text,jsonb),public.my_households(),public.invite_member(uuid,text),public.accept_invitation(),public.push_snapshot(uuid,jsonb,bigint) to authenticated;

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('casa-supports','casa-supports',false,5242880,array['application/pdf','image/jpeg','image/png','image/webp','image/heic','image/heif'])
on conflict(id) do update set public=false,file_size_limit=excluded.file_size_limit,allowed_mime_types=excluded.allowed_mime_types;

create policy "Household supports read" on storage.objects for select to authenticated
 using (bucket_id='casa-supports' and public.is_member((split_part(name,'/',1))::uuid));
create policy "Household supports insert" on storage.objects for insert to authenticated
 with check (bucket_id='casa-supports' and public.can_edit((split_part(name,'/',1))::uuid));
create policy "Household supports update" on storage.objects for update to authenticated
 using (bucket_id='casa-supports' and public.can_edit((split_part(name,'/',1))::uuid))
 with check (bucket_id='casa-supports' and public.can_edit((split_part(name,'/',1))::uuid));
create policy "Household supports delete" on storage.objects for delete to authenticated
 using (bucket_id='casa-supports' and public.can_edit((split_part(name,'/',1))::uuid));

-- Administración de permisos por parte del propietario. No se permite degradar al dueño.
create or replace function public.set_member_role(p_household uuid,p_email text,p_role text)
returns boolean language plpgsql security definer set search_path=public as $$
declare recipient uuid;
begin
 if p_role not in ('admin','editor','viewer') then raise exception 'INVALID_ROLE';end if;
 if not exists(select 1 from public.memberships where household_id=p_household and user_id=auth.uid() and role='owner') then raise exception 'OWNER_REQUIRED';end if;
 select id into recipient from auth.users where lower(email)=lower(trim(p_email)) and email_confirmed_at is not null;
 if recipient is null then raise exception 'ACCOUNT_NOT_FOUND';end if;
 update public.memberships set role=p_role where household_id=p_household and user_id=recipient and role<>'owner';
 if not found then raise exception 'MEMBER_NOT_FOUND_OR_OWNER';end if;
 return true;
end $$;
revoke all on function public.set_member_role(uuid,text,text) from public;
grant execute on function public.set_member_role(uuid,text,text) to authenticated;

-- Lista de integrantes: solo propietario o administrador de ESTA casa.
create or replace function public.household_members(p_household uuid)
returns table(email text,role text)
language plpgsql stable security definer set search_path = '' as $$
begin
 if not exists (
   select 1 from public.memberships m where m.household_id=p_household
   and m.user_id=(select auth.uid()) and m.role in ('owner','admin')
 ) then raise exception 'ADMIN_REQUIRED';end if;
 return query
 select u.email::text,m.role::text from public.memberships m
 join auth.users u on u.id=m.user_id
 where m.household_id=p_household order by m.joined_at;
end $$;
revoke all on function public.household_members(uuid) from public;
grant execute on function public.household_members(uuid) to authenticated;


-- Si empiezas con un proyecto nuevo, también instala la administración de dos casas.
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
