-- Supabase Dashboard > SQL Editor တွင် run ပါ။
create table if not exists public.user_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'customer' check (role in ('customer','admin')),
  created_at timestamptz not null default now()
);
alter table public.user_roles enable row level security;

drop policy if exists "Users can read their own role" on public.user_roles;
create policy "Users can read their own role"
on public.user_roles for select to authenticated
using (user_id = (select auth.uid()));

create or replace function public.create_customer_role()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.user_roles (user_id, role)
  values (new.id, 'customer')
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_add_role on auth.users;
create trigger on_auth_user_created_add_role
after insert on auth.users
for each row execute procedure public.create_customer_role();

-- Customer အကောင့်ဖွင့်ပြီးနောက် Admin တစ်ဦးကို ကိုယ်တိုင်သတ်မှတ်ရန်
-- အောက်က email ကို Admin ၏ email ဖြင့် အစားထိုးပြီး SQL Editor တွင် run ပါ။
-- insert into public.user_roles (user_id, role)
-- select id, 'admin' from auth.users where email = 'YOUR_ADMIN_EMAIL'
-- on conflict (user_id) do update set role = 'admin';

-- Browser ထဲတွင် service_role / secret key မထည့်ပါနှင့်။
-- Bookings table နှင့် Admin API များတွင်လည်း သီးခြား RLS/role စစ်ဆေးမှု မဖြစ်မနေလိုအပ်သည်။
