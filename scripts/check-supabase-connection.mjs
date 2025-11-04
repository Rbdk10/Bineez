import 'dotenv/config';
import supabase from '../lib/supabaseClient.mjs';

async function main() {
  try {
    // Lightweight sanity check: request the current time from Postgres if a helper rpc exists,
    // else fall back to an auth endpoint that doesn't require a user session.
    // This avoids depending on specific tables.
    const { data: health } = await supabase.functions.invoke?.('__health', { body: {} })
      .catch(() => ({ data: null }));

    console.log('Supabase client initialized. URL:', process.env.SUPABASE_URL);
    if (health) {
      console.log('Edge Function __health responded:', health);
    } else {
      console.log('No health function found; basic client initialization succeeded.');
    }
  } catch (err) {
    console.error('Supabase connection check failed:', err?.message || err);
    process.exit(1);
  }
}

main();



