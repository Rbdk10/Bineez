import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anon = import.meta.env.VITE_SUPABASE_ANON_KEY;
const supabase = createClient(url, anon);

export async function requireAuthOrRedirect() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    window.location.href = '/auth/index.html';
    return false;
  }
  return true;
}

export async function signOutAndRedirect() {
  await supabase.auth.signOut();
  window.location.href = '/auth/index.html';
}


