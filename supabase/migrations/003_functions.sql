-- 003_functions.sql
-- Helper functions for bracket utilities (minimal, non-opinionated)

-- Compute next round number given participant count; returns integer
create or replace function public.next_round_count(participants int)
returns int language sql immutable as $$
  select ceil(log(2, greatest(participants, 1)))::int;
$$;

-- Mark match winner and optionally advance to next round
-- Note: advancement wiring (mapping position -> next match) is app-defined; this function only records winner
create or replace function public.set_match_winner(p_match_id uuid, p_winner_item_id uuid)
returns void language plpgsql as $$
begin
  update public.matches
    set winner_participant_id = p_winner_item_id,
        updated_at = now()
  where id = p_match_id;
end $$;


