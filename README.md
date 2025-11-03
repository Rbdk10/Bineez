# Bineez

Blank homepage scaffold and Supabase-ready project.

## Prerequisites
- Node 18+

## Install
```bash
npm install
```

## Dev server
```bash
npm run dev
# serves ./public on http://localhost:5173
```

## Build/Serve static (simple)
```bash
npm start
# serves ./public on http://localhost:8080
```

## Env (Supabase)
Create `.env` with:
```bash
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
```

## Database
Run SQL in `supabase/migrations` in order. See `supabase/README_DB.md`.

## Files
- public/index.html — blank homepage
- public/styles.css — design tokens and base styles
- styleguide.html — full visual style guide
- lib/supabaseClient.mjs — Supabase web client


