import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anon = import.meta.env.VITE_SUPABASE_ANON_KEY;
const supabase = createClient(url, anon);

document.addEventListener('DOMContentLoaded', async () => {
  const form = document.getElementById('auth-form');
  const emailEl = document.getElementById('email');
  const passwordEl = document.getElementById('password');
  const statusEl = document.getElementById('auth-status');
  const btnSignIn = document.getElementById('sign-in');
  const btnRegister = document.getElementById('register');

  // If already logged in, go home
  const { data: { session } } = await supabase.auth.getSession();
  if (session) {
    window.location.href = '/index.html';
    return;
  }

  form.addEventListener('submit', (e) => e.preventDefault());

  btnSignIn.addEventListener('click', async (e) => {
    e.preventDefault();
    await handleAuth('signin');
  });

  btnRegister.addEventListener('click', async (e) => {
    e.preventDefault();
    await handleAuth('signup');
  });

  async function handleAuth(mode) {
    statusEl.textContent = '';
    const email = emailEl.value.trim();
    const password = passwordEl.value;
    if (!email || !password) {
      statusEl.textContent = 'Email and password are required';
      statusEl.style.color = '#c62828';
      return;
    }
    try {
      let error;
      if (mode === 'signup') {
        ({ error } = await supabase.auth.signUp({ email, password }));
      } else {
        ({ error } = await supabase.auth.signInWithPassword({ email, password }));
      }
      if (error) throw error;
      // Session is set on success
      window.location.href = '/index.html';
    } catch (err) {
      statusEl.textContent = err.message || 'Authentication failed';
      statusEl.style.color = '#c62828';
    }
  }
});


