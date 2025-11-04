-- 002_rls_policies.sql
-- Enable RLS and define policies

-- Enable RLS
alter table public.profiles enable row level security;
alter table public.rankings enable row level security;
alter table public.ranking_items enable row level security;
alter table public.matches enable row level security;
alter table public.match_votes enable row level security;

-- Profiles
drop policy if exists "Profiles are readable by all" on public.profiles;
create policy "Profiles are readable by all" on public.profiles
for select using (true);

drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile" on public.profiles
for insert with check (auth.uid() = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile" on public.profiles
for update using (auth.uid() = id);

-- Rankings
drop policy if exists "Public or own rankings are selectable" on public.rankings;
create policy "Public or own rankings are selectable" on public.rankings
for select using (
  visibility in ('public','unlisted') or owner_id = auth.uid()
);

drop policy if exists "Users can insert rankings they own" on public.rankings;
create policy "Users can insert rankings they own" on public.rankings
for insert with check (owner_id = auth.uid());

drop policy if exists "Owners can update their rankings" on public.rankings;
create policy "Owners can update their rankings" on public.rankings
for update using (owner_id = auth.uid());

drop policy if exists "Owners can delete their rankings" on public.rankings;
create policy "Owners can delete their rankings" on public.rankings
for delete using (owner_id = auth.uid());

-- Ranking Items
drop policy if exists "Items selectable if parent visible to user" on public.ranking_items;
create policy "Items selectable if parent visible to user" on public.ranking_items
for select using (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id
      and (r.visibility in ('public','unlisted') or r.owner_id = auth.uid())
  )
);

drop policy if exists "Owners can insert items" on public.ranking_items;
create policy "Owners can insert items" on public.ranking_items
for insert with check (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id and r.owner_id = auth.uid()
  )
);

drop policy if exists "Owners can update items" on public.ranking_items;
create policy "Owners can update items" on public.ranking_items
for update using (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id and r.owner_id = auth.uid()
  )
);

drop policy if exists "Owners can delete items" on public.ranking_items;
create policy "Owners can delete items" on public.ranking_items
for delete using (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id and r.owner_id = auth.uid()
  )
);

-- Matches
drop policy if exists "Matches selectable if parent visible to user" on public.matches;
create policy "Matches selectable if parent visible to user" on public.matches
for select using (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id
      and (r.visibility in ('public','unlisted') or r.owner_id = auth.uid())
  )
);

drop policy if exists "Owners manage matches" on public.matches;
create policy "Owners manage matches" on public.matches
for all using (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id and r.owner_id = auth.uid()
  )
) with check (
  exists (
    select 1 from public.rankings r
    where r.id = ranking_id and r.owner_id = auth.uid()
  )
);

-- Match Votes
drop policy if exists "Votes selectable for visible rankings" on public.match_votes;
create policy "Votes selectable for visible rankings" on public.match_votes
for select using (
  exists (
    select 1 from public.matches m
    join public.rankings r on r.id = m.ranking_id
    where m.id = match_id and (r.visibility in ('public','unlisted') or r.owner_id = auth.uid())
  )
);

drop policy if exists "Authenticated users can vote on public rankings" on public.match_votes;
create policy "Authenticated users can vote on public rankings" on public.match_votes
for insert with check (
  auth.uid() is not null
  and exists (
    select 1 from public.matches m
    join public.rankings r on r.id = m.ranking_id
    where m.id = match_id and r.visibility = 'public'
  )
);

drop policy if exists "Users can delete their own votes" on public.match_votes;
create policy "Users can delete their own votes" on public.match_votes
for delete using (voter_id = auth.uid());



