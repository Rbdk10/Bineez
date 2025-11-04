-- 004_indexes.sql
-- Helpful indexes for query performance

-- Rankings
create index if not exists idx_rankings_owner on public.rankings(owner_id);
create index if not exists idx_rankings_visibility on public.rankings(visibility);

-- Items
create index if not exists idx_items_ranking on public.ranking_items(ranking_id);
create index if not exists idx_items_seed on public.ranking_items(ranking_id, seed);

-- Matches
create index if not exists idx_matches_ranking on public.matches(ranking_id);
create index if not exists idx_matches_round on public.matches(ranking_id, round);

-- Votes
create index if not exists idx_votes_match on public.match_votes(match_id);
create index if not exists idx_votes_voter on public.match_votes(voter_id);



