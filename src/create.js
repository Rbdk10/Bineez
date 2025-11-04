import { createClient } from '@supabase/supabase-js';
import { requireAuthOrRedirect } from './session-gate.js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anon = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !anon) {
  console.error('Missing VITE_SUPABASE_URL or VITE_SUPABASE_ANON_KEY');
  alert('Supabase env not configured. Set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY in .env');
}

const supabase = createClient(url, anon);

document.addEventListener('DOMContentLoaded', async () => {
  const ok = await requireAuthOrRedirect();
  if (!ok) return;
  const form = document.getElementById('create-form');
  const nameInput = document.getElementById('name');
  const statusEl = document.getElementById('status');
  const modal = document.getElementById('success-modal');
  const modalClose = document.getElementById('modal-close');
  const confirmModal = document.getElementById('confirm-modal');
  const confirmCancel = document.getElementById('confirm-cancel');
  const confirmYes = document.getElementById('confirm-yes');
  let pendingName = '';

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    statusEl.textContent = '';

    const name = nameInput.value.trim();
    if (!name) {
      statusEl.textContent = 'Please fill all required fields.';
      statusEl.style.color = '#c62828';
      return;
    }
    // Open confirm modal; actual insert happens on Yes
    pendingName = name;
    if (confirmModal) {
      confirmModal.classList.add('show');
      confirmModal.setAttribute('aria-hidden', 'false');
    }
  });

  if (modalClose) {
    modalClose.addEventListener('click', (e) => {
      e.preventDefault();
      if (modal) {
        modal.classList.remove('show');
        modal.setAttribute('aria-hidden', 'true');
      }
      form.reset();
      nameInput.focus();
    });
  }

  if (confirmCancel) {
    confirmCancel.addEventListener('click', (e) => {
      e.preventDefault();
      if (confirmModal) {
        confirmModal.classList.remove('show');
        confirmModal.setAttribute('aria-hidden', 'true');
      }
    });
  }

  if (confirmYes) {
    confirmYes.addEventListener('click', async (e) => {
      e.preventDefault();
      confirmYes.disabled = true;
      statusEl.textContent = '';
      try {
        const { error } = await supabase
          .from('rankings')
          .insert([{ name: pendingName }]);
        if (error) {
          throw error;
        }
        if (confirmModal) {
          confirmModal.classList.remove('show');
          confirmModal.setAttribute('aria-hidden', 'true');
        }
        if (modal) {
          modal.classList.add('show');
          modal.setAttribute('aria-hidden', 'false');
        } else {
          alert('Ranking created!');
          window.location.href = './index.html';
        }
      } catch (err) {
        console.error(err);
        statusEl.textContent = err.message || 'Failed to create ranking';
        statusEl.style.color = '#c62828';
      } finally {
        confirmYes.disabled = false;
      }
    });
  }
});


