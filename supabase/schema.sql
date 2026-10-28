-- Mercado Claro: schema inicial para Supabase/PostgreSQL.
-- Execute no SQL Editor de um projeto novo. RLS está ativado para dados privados.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.watchlists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'Minha lista',
  created_at timestamptz not null default now(),
  unique (user_id, name)
);

create table if not exists public.watchlist_items (
  id uuid primary key default gen_random_uuid(),
  watchlist_id uuid not null references public.watchlists(id) on delete cascade,
  symbol text not null,
  label text not null,
  asset_type text not null check (asset_type in ('stock','index','fx','commodity','crypto')),
  created_at timestamptz not null default now(),
  unique (watchlist_id, symbol)
);

create table if not exists public.alerts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  symbol text not null,
  condition text not null check (condition in ('above','below','percent_up','percent_down')),
  target_value numeric not null check (target_value >= 0),
  active boolean not null default true,
  last_triggered_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.saved_dashboards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  configuration jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.saved_simulations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'Simulação',
  initial_amount numeric not null check (initial_amount >= 0),
  monthly_contribution numeric not null check (monthly_contribution >= 0),
  monthly_rate numeric not null check (monthly_rate >= 0 and monthly_rate <= 1),
  months integer not null check (months between 1 and 1200),
  created_at timestamptz not null default now()
);

-- Cotação pública normalizada; só o backend/service role deve escrever.
create table if not exists public.market_quotes (
  id bigint generated always as identity primary key,
  symbol text not null,
  asset_type text not null check (asset_type in ('stock','index','fx','commodity','crypto')),
  price numeric not null,
  currency text not null default 'BRL',
  unit text,
  market text,
  source text not null,
  observed_at timestamptz not null,
  fetched_at timestamptz not null default now(),
  unique (symbol, source, observed_at)
);
create index if not exists market_quotes_symbol_observed_idx
  on public.market_quotes(symbol, observed_at desc);
create index if not exists alerts_active_user_idx on public.alerts(user_id, active);

alter table public.profiles enable row level security;
alter table public.watchlists enable row level security;
alter table public.watchlist_items enable row level security;
alter table public.alerts enable row level security;
alter table public.saved_dashboards enable row level security;
alter table public.saved_simulations enable row level security;
alter table public.market_quotes enable row level security;

create policy "profiles read own" on public.profiles for select to authenticated using (auth.uid() = id);
create policy "profiles insert own" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "profiles update own" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "watchlists own all" on public.watchlists for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "watchlist items own all" on public.watchlist_items for all to authenticated
using (exists (select 1 from public.watchlists w where w.id = watchlist_id and w.user_id = auth.uid()))
with check (exists (select 1 from public.watchlists w where w.id = watchlist_id and w.user_id = auth.uid()));
create policy "alerts own all" on public.alerts for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dashboards own all" on public.saved_dashboards for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "simulations own all" on public.saved_simulations for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Cotações podem ser lidas anonimamente; não permitir escrita pelo navegador.
create policy "market quotes public read" on public.market_quotes for select to anon, authenticated using (true);

-- Criação automática de perfil para novas contas.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

-- IMPORTANTE: não inclua service_role key em HTML/JavaScript público.
-- Pagamentos, notificações e ingestão de dados devem rodar no servidor/Edge Functions.
