# Bineez

Blank homepage scaffold and Supabase-ready project.

## Prerequisites
- Node 18+

## Install
```bash
npm install
```

## Dev server (Vite)
```bash
npm run dev
# http://localhost:5173
```

## Build/Preview
```bash
npm run build
npm run preview
```

## Env (Supabase via Vite)
Create a `.env` file in the project root:
```bash
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

## Database
Run SQL in `supabase/migrations` in order. See `supabase/README_DB.md`.

## Files
- public/index.html — blank homepage
- public/styles.css — design tokens and base styles
- public/create.html — create rankings form (inserts into Supabase)
- styleguide.html — full visual style guide
- lib/supabaseClient.mjs — Supabase web client
- src/main.js — homepage entry
- src/create.js — create page logic using env vars
- src/auth.js — email/password auth (sign-in & register)
- src/session-gate.js — redirect to /auth when not signed in
- public/auth/index.html — authentication page



