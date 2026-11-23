-- Sayarnge Booking: assign the existing Supabase account as admin.
-- Run this in Supabase Dashboard > SQL Editor AFTER supabase-schema.sql
-- has been executed and AFTER the user has signed up with this email.
-- This does not contain or change the user's password.

do $$
declare
  target_user_id uuid;
begin
  select id into target_user_id
  from auth.users
  where id = 'c023cfb9-a8b2-4203-8eac-0c2496c2b3b0'::uuid
    and lower(email) = lower('sayarngeofficial@gmail.com');

  if target_user_id is null then
    raise exception 'Admin account not found. Sign up in Supabase Auth with sayarngeofficial@gmail.com, then run this SQL again.';
  end if;

  insert into public.user_roles (user_id, role)
  values (target_user_id, 'admin')
  on conflict (user_id)
  do update set role = 'admin';
end
$$;

-- Verify the result:
select u.email, r.user_id, r.role
from auth.users u
join public.user_roles r on r.user_id = u.id
where u.id = 'c023cfb9-a8b2-4203-8eac-0c2496c2b3b0'::uuid;
