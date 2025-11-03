# Supabase Setup (Bineez)

## Env variables
Create a `.env` file in the project root with:

```
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
```

These are used by `lib/supabaseClient.mjs`.

## Install dependency

```
npm install @supabase/supabase-js dotenv
```

## Client usage

```js
// example.mjs
import supabase from './lib/supabaseClient.mjs';

const { data, error } = await supabase.from('your_table').select('*').limit(1);
if (error) throw error;
console.log(data);
```

## Check connection script
A lightweight check is available:

```
node scripts/check-supabase-connection.mjs
```

It validates env vars and attempts a minimal call. If you have an Edge Function named `__health`, it will invoke it; otherwise it reports that initialization succeeded.

## Notes
- Never commit `.env` (already in `.gitignore`).
- For server-only keys (service_role), create a separate server-side client and never expose it to the browser.

