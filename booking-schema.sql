-- Sayarnge Booking: booking records
-- Supabase Dashboard > SQL Editor တွင် run ပါ။
-- အရင် supabase-schema.sql ကို run ပြီးမှ ဤဖိုင်ကို run ပါ။

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  customer_name text not null,
  phone text not null,
  service text not null,
  birth_details text,
  partner_details text,
  question text,
  customer_photo_path text,
  payment_slip_path text,
  payment_status text not null default 'pending'
    check (payment_status in ('pending','approved','rejected')),
  booking_status text not null default 'new'
    check (booking_status in ('new','in_progress','completed','cancelled')),
  result_text text,
  result_pdf_path text,
  result_photo_path text,
  delivery_channel text,
  admin_note text
);

alter table public.bookings enable row level security;

-- Public customer can submit a booking without creating an account.
drop policy if exists "Anyone can submit booking" on public.bookings;
create policy "Anyone can submit booking"
on public.bookings for insert to anon, authenticated
with check (
  length(trim(customer_name)) between 1 and 120
  and length(trim(phone)) between 5 and 40
  and length(trim(service)) between 1 and 160
);

-- Only signed-in users with the admin role can view or manage bookings.
drop policy if exists "Admins can view bookings" on public.bookings;
create policy "Admins can view bookings"
on public.bookings for select to authenticated
using (
  exists (
    select 1 from public.user_roles
    where user_id = (select auth.uid()) and role = 'admin'
  )
);

drop policy if exists "Admins can update bookings" on public.bookings;
create policy "Admins can update bookings"
on public.bookings for update to authenticated
using (
  exists (
    select 1 from public.user_roles
    where user_id = (select auth.uid()) and role = 'admin'
  )
)
with check (
  exists (
    select 1 from public.user_roles
    where user_id = (select auth.uid()) and role = 'admin'
  )
);

-- Public users cannot read, edit, or delete booking records.
