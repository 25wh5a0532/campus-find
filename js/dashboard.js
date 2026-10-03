/**
 * dashboard.js — CampusFind dashboard page logic
 * Calculates all stats dynamically from localStorage. No hard-coded numbers.
 */

document.addEventListener('DOMContentLoaded', () => {
  // Auth guard — redirect if not logged in
  if (!Auth.requireAuth()) return;

  const user = CampusData.getCurrentUser();
  App.renderNav('dashboard');

  // ─── Welcome message ────────────────────────────────────────────────────────
  const welcomeEl = document.getElementById('welcome-name');
  if (welcomeEl) welcomeEl.textContent = user.name;

  // ─── Load stats ─────────────────────────────────────────────────────────────
  refreshStats();

  // ─── Recent activity ────────────────────────────────────────────────────────
  renderRecentActivity();

  // ─── Quick action buttons ────────────────────────────────────────────────────
  document.getElementById('btn-report-lost')?.addEventListener('click', () => {
    window.location.href = 'report-lost.html';
  });
  document.getElementById('btn-report-found')?.addEventListener('click', () => {
    window.location.href = 'report-found.html';
  });
  document.getElementById('btn-browse')?.addEventListener('click', () => {
    window.location.href = 'browse.html';
  });
  document.getElementById('btn-my-reports')?.addEventListener('click', () => {
    window.location.href = 'my-reports.html';
  });
});

function refreshStats() {
  const stats = CampusData.getStats();

  setStatValue('stat-lost', stats.lost);
  setStatValue('stat-found', stats.found);
  setStatValue('stat-total', stats.total);
  setStatValue('stat-my-reports', stats.myReports);
}

function setStatValue(id, value) {
  const el = document.getElementById(id);
  if (el) el.textContent = value;
}

function renderRecentActivity() {
  const container = document.getElementById('recent-activity');
  if (!container) return;

  const user = CampusData.getCurrentUser();
  const allReports = CampusData.getReports();

  // Last 5 reports (global, most recent first)
  const recent = [...allReports]
    .sort((a, b) => new Date(b.date) - new Date(a.date))
    .slice(0, 5);

  if (recent.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <div class="empty-icon">📋</div>
        <p>No reports have been submitted yet.</p>
        <a href="report-lost.html" class="btn btn-primary">Submit Your First Report</a>
      </div>
    `;
    return;
  }

  container.innerHTML = recent.map(report => `
    <div class="activity-item">
      <div class="activity-icon">${App.categoryIcon(report.category)}</div>
      <div class="activity-info">
        <div class="activity-title">${App.escapeHtml(report.itemName)}</div>
        <div class="activity-meta">
          ${App.statusBadge(report.type)}
          <span>${App.escapeHtml(report.location || 'Unknown location')}</span>
          <span>${App.timeAgo(report.date)}</span>
        </div>
      </div>
    </div>
  `).join('');
}
