/**
 * data.js — CampusFind localStorage data layer
 * All reads/writes to localStorage go through this module.
 */

const KEYS = {
  USERS: 'cf_users',
  REPORTS: 'cf_reports',
  CURRENT_USER: 'cf_current_user',
};

// ─── Users ────────────────────────────────────────────────────────────────────

function getUsers() {
  try {
    return JSON.parse(localStorage.getItem(KEYS.USERS) || '[]');
  } catch {
    return [];
  }
}

function saveUsers(users) {
  localStorage.setItem(KEYS.USERS, JSON.stringify(users));
}

function getUserById(id) {
  return getUsers().find(u => u.id === id) || null;
}

function getUserByEmail(email) {
  return getUsers().find(u => u.email.toLowerCase() === email.toLowerCase()) || null;
}

function addUser(user) {
  const users = getUsers();
  users.push(user);
  saveUsers(users);
}

// ─── Reports ──────────────────────────────────────────────────────────────────

function getReports() {
  try {
    return JSON.parse(localStorage.getItem(KEYS.REPORTS) || '[]');
  } catch {
    return [];
  }
}

function saveReports(reports) {
  localStorage.setItem(KEYS.REPORTS, JSON.stringify(reports));
}

function addReport(report) {
  const reports = getReports();
  reports.push(report);
  saveReports(reports);
}

function getReportsByUserId(userId) {
  return getReports().filter(r => r.userId === userId);
}

function getReportById(id) {
  return getReports().find(r => r.id === id) || null;
}

function deleteReport(id) {
  const reports = getReports().filter(r => r.id !== id);
  saveReports(reports);
}

// ─── Session ──────────────────────────────────────────────────────────────────

function getCurrentUser() {
  try {
    return JSON.parse(localStorage.getItem(KEYS.CURRENT_USER) || 'null');
  } catch {
    return null;
  }
}

function setCurrentUser(user) {
  localStorage.setItem(KEYS.CURRENT_USER, JSON.stringify(user));
}

function clearCurrentUser() {
  localStorage.removeItem(KEYS.CURRENT_USER);
}

// ─── Stats (calculated dynamically — never hard-coded) ────────────────────────

function getStats() {
  const reports = getReports();
  const currentUser = getCurrentUser();

  return {
    total: reports.length,
    lost: reports.filter(r => r.type === 'lost').length,
    found: reports.filter(r => r.type === 'found').length,
    myClaims: currentUser
      ? reports.filter(r => r.userId === currentUser.id && r.type === 'found').length
      : 0,
    myReports: currentUser
      ? reports.filter(r => r.userId === currentUser.id).length
      : 0,
  };
}

// ─── Unique ID generator ──────────────────────────────────────────────────────

function generateId(prefix) {
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
}

// ─── Export ───────────────────────────────────────────────────────────────────

window.CampusData = {
  getUsers,
  getUserById,
  getUserByEmail,
  addUser,
  getReports,
  addReport,
  getReportsByUserId,
  getReportById,
  deleteReport,
  getCurrentUser,
  setCurrentUser,
  clearCurrentUser,
  getStats,
  generateId,
};
