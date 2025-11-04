# Supabase Migrations for Bineez

This folder contains SQL scripts you can run in Supabase (SQL editor) or via the CLI to set up the database for rankings, items, matches, and votes.

## Files
- `001_init.sql`: Types, tables, triggers, and a vote count view
- `002_rls_policies.sql`: Enables RLS and defines policies
- `003_functions.sql`: Utility functions for brackets
- `004_indexes.sql`: Helpful indexes

## Apply order
Run the files in numerical order:

1. `001_init.sql`
2. `002_rls_policies.sql`
3. `003_functions.sql`
4. `004_indexes.sql`

## Notes
- Uses `gen_random_uuid()` from `pgcrypto` (enabled by default on Supabase). If needed, ensure the extension is enabled.
- Auth is handled via `auth.users` (managed by Supabase). The `profiles` table mirrors that user id for public data.
- RLS policies allow:
  - Everyone to read public/unlisted rankings and their items/matches
  - Owners to manage their own rankings/items/matches
  - Any authenticated user to insert a single vote per match on public rankings
- Adjust policies as your product rules evolve (e.g., lock voting, private tournaments, team-only access).


