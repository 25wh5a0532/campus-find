/**
 * reports.js — CampusFind report submission and listing logic
 * Handles: Report Lost, Report Found, Browse Items, My Reports pages.
 */

// ─── Report form (used by report-lost.html and report-found.html) ─────────────

function initReportForm(type) {
  // Auth guard
  if (!Auth.requireAuth()) return;

  const user = CampusData.getCurrentUser();
  App.renderNav(type === 'lost' ? 'report-lost' : 'report-found');

  const form = document.getElementById('report-form');
  if (!form) return;

  // Set page-specific labels
  const typeLabel = document.getElementById('report-type-label');
  if (typeLabel) typeLabel.textContent = type === 'lost' ? 'Report Lost Item' : 'Report Found Item';

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    App.clearFormError('form-error');

    const itemName = form.querySelector('#item-name')?.value.trim();
    const category = form.querySelector('#category')?.value;
    const description = form.querySelector('#description')?.value.trim();
    const location = form.querySelector('#location')?.value.trim();
    const date = form.querySelector('#date')?.value;
    const color = form.querySelector('#color')?.value.trim();
    const brand = form.querySelector('#brand')?.value.trim();

    // Validation
    if (!itemName) return App.showFormError('form-error', 'Item name is required.');
    if (!category) return App.showFormError('form-error', 'Please select a category.');
    if (!description) return App.showFormError('form-error', 'Description is required.');
    if (!location) return App.showFormError('form-error', 'Location is required.');
    if (!date) return App.showFormError('form-error', 'Date is required.');

    const report = {
      id: CampusData.generateId('report'),
      userId: user.id,
      userName: user.name,
      type: type,          // 'lost' | 'found'
      itemName,
      category,
      description,
      location,
      date,
      color: color || '',
      brand: brand || '',
      status: type === 'lost' ? 'active' : 'found',
      createdAt: new Date().toISOString(),
    };

    CampusData.addReport(report);
    App.toast(`Your "${itemName}" report has been submitted!`, 'success');

    // Redirect to my-reports after short delay
    setTimeout(() => {
      window.location.href = 'my-reports.html';
    }, 1200);
  });
}

// ─── Browse Items page ────────────────────────────────────────────────────────

function initBrowsePage() {
  App.renderNav('browse');

  const container = document.getElementById('browse-grid');
  const searchInput = document.getElementById('search-input');
  const filterType = document.getElementById('filter-type');
  const filterCategory = document.getElementById('filter-category');
  const resultCount = document.getElementById('result-count');

  function renderItems() {
    const query = searchInput?.value.trim().toLowerCase() || '';
    const type = filterType?.value || '';
    const category = filterCategory?.value || '';

    let items = CampusData.getReports();

    // Filter
    if (type) items = items.filter(r => r.type === type);
    if (category) items = items.filter(r => r.category === category);
    if (query) {
      items = items.filter(r =>
        r.itemName.toLowerCase().includes(query) ||
        r.description.toLowerCase().includes(query) ||
        r.location.toLowerCase().includes(query) ||
        (r.brand || '').toLowerCase().includes(query) ||
        (r.color || '').toLowerCase().includes(query)
      );
    }

    // Sort newest first
    items.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    if (resultCount) resultCount.textContent = `${items.length} item${items.length !== 1 ? 's' : ''} found`;

    if (!container) return;

    if (items.length === 0) {
      container.innerHTML = `
        <div class="empty-state full-width">
          <div class="empty-icon">🔍</div>
          <h3>No items found</h3>
          <p>${CampusData.getReports().length === 0
            ? 'No lost or found items have been reported yet.'
            : 'No items match your search. Try different keywords or filters.'
          }</p>
          ${Auth.isLoggedIn()
            ? '<a href="report-lost.html" class="btn btn-primary">Report Lost Item</a>'
            : '<a href="register.html" class="btn btn-primary">Register to Submit a Report</a>'
          }
        </div>
      `;
      return;
    }

    container.innerHTML = items.map(report => renderReportCard(report)).join('');
  }

  // Wire up filters
  searchInput?.addEventListener('input', renderItems);
  filterType?.addEventListener('change', renderItems);
  filterCategory?.addEventListener('change', renderItems);

  // Initial render
  renderItems();
}

// ─── My Reports page ─────────────────────────────────────────────────────────

function initMyReportsPage() {
  if (!Auth.requireAuth()) return;

  const user = CampusData.getCurrentUser();
  App.renderNav('my-reports');

  const container = document.getElementById('my-reports-list');
  if (!container) return;

  const reports = CampusData.getReportsByUserId(user.id);

  // Sort newest first
  reports.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const countEl = document.getElementById('my-reports-count');
  if (countEl) countEl.textContent = reports.length;

  if (reports.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <div class="empty-icon">📝</div>
        <h3>No reports yet</h3>
        <p>You haven't submitted any reports yet.</p>
        <div class="empty-actions">
          <a href="report-lost.html" class="btn btn-primary">Report Lost Item</a>
          <a href="report-found.html" class="btn btn-outline">Report Found Item</a>
        </div>
      </div>
    `;
    return;
  }

  container.innerHTML = reports.map(report => `
    <div class="report-row" data-id="${report.id}">
      <div class="report-row-icon">${App.categoryIcon(report.category)}</div>
      <div class="report-row-info">
        <div class="report-row-title">${App.escapeHtml(report.itemName)}</div>
        <div class="report-row-meta">
          ${App.statusBadge(report.type)}
          <span>📍 ${App.escapeHtml(report.location)}</span>
          <span>📅 ${App.formatDate(report.date)}</span>
          ${report.brand ? `<span>🏷️ ${App.escapeHtml(report.brand)}</span>` : ''}
        </div>
        <div class="report-row-desc">${App.escapeHtml(report.description)}</div>
      </div>
      <div class="report-row-actions">
        <button class="btn btn-danger btn-sm" onclick="deleteMyReport('${report.id}')">Delete</button>
      </div>
    </div>
  `).join('');
}

function deleteMyReport(id) {
  if (!confirm('Are you sure you want to delete this report?')) return;
  CampusData.deleteReport(id);
  App.toast('Report deleted.', 'info');
  initMyReportsPage();
}

// ─── Shared card renderer ─────────────────────────────────────────────────────

function renderReportCard(report) {
  const reporter = CampusData.getUserById(report.userId);
  const reporterName = reporter ? reporter.name : report.userName || 'Anonymous';

  return `
    <div class="item-card">
      <div class="item-card-header ${report.type === 'lost' ? 'lost-header' : 'found-header'}">
        <div class="item-card-icon">${App.categoryIcon(report.category)}</div>
        ${App.statusBadge(report.type)}
      </div>
      <div class="item-card-body">
        <h3 class="item-card-title">${App.escapeHtml(report.itemName)}</h3>
        <p class="item-card-desc">${App.escapeHtml(report.description)}</p>
        <div class="item-card-meta">
          <span>📍 ${App.escapeHtml(report.location)}</span>
          <span>📅 ${App.formatDate(report.date)}</span>
          ${report.color ? `<span>🎨 ${App.escapeHtml(report.color)}</span>` : ''}
          ${report.brand ? `<span>🏷️ ${App.escapeHtml(report.brand)}</span>` : ''}
        </div>
      </div>
      <div class="item-card-footer">
        <span class="item-reporter">Reported by ${App.escapeHtml(reporterName)}</span>
        <span class="item-time">${App.timeAgo(report.createdAt)}</span>
      </div>
    </div>
  `;
}

// Expose globals needed by HTML onclick handlers
window.deleteMyReport = deleteMyReport;
window.initReportForm = initReportForm;
window.initBrowsePage = initBrowsePage;
window.initMyReportsPage = initMyReportsPage;
