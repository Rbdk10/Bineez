-- 001_init.sql
-- Core schema for Bineez rankings & brackets

-- Extensions (enabled by default in Supabase projects, but safe to create if absent)
create extension if not exists pgcrypto;

-- Types
do $$ begin
  if not exists (select 1 from pg_type where typname = 'ranking_visibility') then
    create type ranking_visibility as enum ('public', 'unlisted', 'private');
  end if;
end $$;

-- Utility function: updated_at timestamp
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

-- Profiles (1:1 with auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text,
  avatar_url text,
  bio text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_profiles_updated_at
before update on public.profiles
for each row execute procedure set_updated_at();

-- Rankings
create table if not exists public.rankings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  visibility ranking_visibility not null default 'public',
  is_bracket boolean not null default true,
  max_seed int,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_rankings_updated_at
before update on public.rankings
for each row execute procedure set_updated_at();

-- Ranking Items (entries/participants)
create table if not exists public.ranking_items (
  id uuid primary key default gen_random_uuid(),
  ranking_id uuid not null references public.rankings(id) on delete cascade,
  label text not null,
  seed int,
  image_url text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(ranking_id, seed)
);

create trigger trg_ranking_items_updated_at
before update on public.ranking_items
for each row execute procedure set_updated_at();

-- Matches (for brackets)
create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  ranking_id uuid not null references public.rankings(id) on delete cascade,
  round int not null,
  position int not null,
  participant_a_id uuid references public.ranking_items(id) on delete set null,
  participant_b_id uuid references public.ranking_items(id) on delete set null,
  winner_participant_id uuid references public.ranking_items(id) on delete set null,
  starts_at timestamptz,
  locked boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(ranking_id, round, position)
);

create trigger trg_matches_updated_at
before update on public.matches
for each row execute procedure set_updated_at();

-- Votes per match
create table if not exists public.match_votes (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references public.matches(id) on delete cascade,
  voter_id uuid not null references auth.users(id) on delete cascade,
  choice text not null check (choice in ('a','b')),
  created_at timestamptz not null default now(),
  unique(match_id, voter_id)
);

-- Helpful views (optional)
create or replace view public.v_match_vote_counts as
select
  m.id as match_id,
  m.ranking_id,
  sum(case when v.choice = 'a' then 1 else 0 end) as votes_a,
  sum(case when v.choice = 'b' then 1 else 0 end) as votes_b,
  count(v.*) as total_votes
from public.matches m
left join public.match_votes v on v.match_id = m.id
group by m.id, m.ranking_id;



