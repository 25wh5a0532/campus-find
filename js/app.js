/**
 * app.js — CampusFind shared utilities
 * Nav rendering, auth-aware UI, toast notifications.
 * Must be loaded after data.js and auth.js.
 */

const App = (() => {

  // ─── Navigation ─────────────────────────────────────────────────────────────

  function renderNav(activePage) {
    const user = CampusData.getCurrentUser();
    const loggedIn = !!user;

    const navEl = document.getElementById('main-nav');
    if (!navEl) return;

    // Pages that highlight in the nav
    const pages = [
      { href: 'index.html', label: 'Home', id: 'home' },
      { href: 'browse.html', label: 'Browse Items', id: 'browse' },
    ];

    const publicLinks = pages.map(p => `
      <a href="${p.href}" class="nav-link${activePage === p.id ? ' active' : ''}">${p.label}</a>
    `).join('');

    let authLinks = '';
    if (loggedIn) {
      authLinks = `
        <a href="dashboard.html" class="nav-link${activePage === 'dashboard' ? ' active' : ''}">Dashboard</a>
        <a href="my-reports.html" class="nav-link${activePage === 'my-reports' ? ' active' : ''}">My Reports</a>
        <div class="nav-user">
          <span class="nav-username">👤 ${escapeHtml(user.name)}</span>
          <button class="btn btn-outline btn-sm" onclick="Auth.logout()">Logout</button>
        </div>
      `;
    } else {
      authLinks = `
        <a href="login.html" class="btn btn-outline btn-sm${activePage === 'login' ? ' active' : ''}">Login</a>
        <a href="register.html" class="btn btn-primary btn-sm${activePage === 'register' ? ' active' : ''}">Register</a>
      `;
    }

    navEl.innerHTML = `
      <div class="nav-container">
        <a href="index.html" class="nav-brand">
          <div class="nav-logo">🔍</div>
          <span>CampusFind</span>
        </a>
        <button class="nav-toggle" onclick="App.toggleMobileNav()" aria-label="Toggle menu">
          <span></span><span></span><span></span>
        </button>
        <div class="nav-links" id="nav-links">
          ${publicLinks}
          ${authLinks}
        </div>
      </div>
    `;
  }

  function toggleMobileNav() {
    const links = document.getElementById('nav-links');
    if (links) links.classList.toggle('open');
  }

  // ─── Toast notifications ─────────────────────────────────────────────────────

  function toast(message, type = 'info', duration = 3500) {
    let container = document.getElementById('toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'toast-container';
      document.body.appendChild(container);
    }

    const t = document.createElement('div');
    t.className = `toast toast-${type}`;
    t.textContent = message;
    container.appendChild(t);

    // Animate in
    requestAnimationFrame(() => t.classList.add('show'));

    setTimeout(() => {
      t.classList.remove('show');
      t.addEventListener('transitionend', () => t.remove());
    }, duration);
  }

  // ─── Form error display ──────────────────────────────────────────────────────

  function showFormError(containerId, message) {
    const el = document.getElementById(containerId);
    if (!el) return;
    el.textContent = message;
    el.style.display = message ? 'block' : 'none';
  }

  function clearFormError(containerId) {
    showFormError(containerId, '');
  }

  // ─── Utility helpers ─────────────────────────────────────────────────────────

  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function formatDate(isoString) {
    if (!isoString) return '';
    try {
      const d = new Date(isoString);
      return d.toLocaleDateString('en-IN', {
        day: '2-digit', month: 'short', year: 'numeric'
      });
    } catch {
      return isoString;
    }
  }

  function timeAgo(isoString) {
    if (!isoString) return '';
    const now = Date.now();
    const then = new Date(isoString).getTime();
    const diff = Math.floor((now - then) / 1000);

    if (diff < 60) return 'just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    if (diff < 604800) return `${Math.floor(diff / 86400)}d ago`;
    return formatDate(isoString);
  }

  // Category icon map
  const CATEGORY_ICONS = {
    electronics: '💻',
    clothing: '👕',
    accessories: '⌚',
    books: '📚',
    documents: '📄',
    keys: '🔑',
    bags: '👜',
    sports: '⚽',
    other: '📦',
  };

  function categoryIcon(cat) {
    return CATEGORY_ICONS[cat] || '📦';
  }

  // Status badge HTML
  function statusBadge(type) {
    if (type === 'lost') return '<span class="badge badge-lost">Lost</span>';
    if (type === 'found') return '<span class="badge badge-found">Found</span>';
    return `<span class="badge">${escapeHtml(type)}</span>`;
  }

  return {
    renderNav,
    toggleMobileNav,
    toast,
    showFormError,
    clearFormError,
    escapeHtml,
    formatDate,
    timeAgo,
    categoryIcon,
    statusBadge,
  };
})();

window.App = App;
