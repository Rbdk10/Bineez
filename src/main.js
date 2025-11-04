import { requireAuthOrRedirect, signOutAndRedirect } from './session-gate.js';

document.addEventListener('DOMContentLoaded', async () => {
  const ok = await requireAuthOrRedirect();
  if (!ok) return;

  const header = document.querySelector('.header .container');
  if (header) {
    const btn = document.createElement('button');
    btn.textContent = 'Sign out';
    btn.style.marginLeft = '12px';
    btn.style.padding = '8px 12px';
    btn.style.border = '2px solid #ffffffaa';
    btn.style.background = 'transparent';
    btn.style.color = '#fff';
    btn.style.borderRadius = '6px';
    btn.style.cursor = 'pointer';
    btn.addEventListener('click', () => signOutAndRedirect());
    header.appendChild(btn);
  }
});


