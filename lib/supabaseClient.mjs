import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  const missing = [
    !supabaseUrl ? 'SUPABASE_URL' : null,
    !supabaseAnonKey ? 'SUPABASE_ANON_KEY' : null,
  ].filter(Boolean).join(', ');
  throw new Error(`Missing required environment variables: ${missing}`);
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
});

export default supabase;



