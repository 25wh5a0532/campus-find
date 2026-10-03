/**
 * auth.js — CampusFind authentication logic
 * Depends on data.js being loaded first.
 */

const Auth = (() => {

  // ─── Register ───────────────────────────────────────────────────────────────

  function register({ name, email, password, confirmPassword }) {
    // Validate inputs
    if (!name || !name.trim()) return { ok: false, error: 'Full name is required.' };
    if (!email || !email.trim()) return { ok: false, error: 'Email is required.' };
    if (!isValidEmail(email)) return { ok: false, error: 'Please enter a valid email address.' };
    if (!password) return { ok: false, error: 'Password is required.' };
    if (password.length < 6) return { ok: false, error: 'Password must be at least 6 characters.' };
    if (password !== confirmPassword) return { ok: false, error: 'Passwords do not match.' };

    // Check duplicate
    if (CampusData.getUserByEmail(email)) {
      return { ok: false, error: 'An account with this email already exists.' };
    }

    // Create user
    const user = {
      id: CampusData.generateId('user'),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: simpleHash(password), // obfuscated; not cryptographic
      createdAt: new Date().toISOString(),
    };

    CampusData.addUser(user);
    return { ok: true, user };
  }

  // ─── Login ──────────────────────────────────────────────────────────────────

  function login({ email, password }) {
    if (!email || !password) return { ok: false, error: 'Email and password are required.' };

    const user = CampusData.getUserByEmail(email);
    if (!user) return { ok: false, error: 'No account found with this email.' };
    if (user.password !== simpleHash(password)) return { ok: false, error: 'Incorrect password.' };

    // Store session (exclude password)
    const session = { id: user.id, name: user.name, email: user.email };
    CampusData.setCurrentUser(session);
    return { ok: true, user: session };
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────

  function logout() {
    CampusData.clearCurrentUser();
    window.location.href = 'login.html';
  }

  // ─── Session helpers ────────────────────────────────────────────────────────

  function isLoggedIn() {
    return CampusData.getCurrentUser() !== null;
  }

  function requireAuth() {
    if (!isLoggedIn()) {
      window.location.href = 'login.html';
      return false;
    }
    return true;
  }

  function redirectIfLoggedIn(dest) {
    if (isLoggedIn()) {
      window.location.href = dest || 'dashboard.html';
      return true;
    }
    return false;
  }

  // ─── Tiny obfuscation (not real crypto — for demo only) ─────────────────────

  function simpleHash(str) {
    let hash = 5381;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) + hash) + str.charCodeAt(i);
      hash |= 0;
    }
    return 'h_' + Math.abs(hash).toString(16);
  }

  // ─── Email validator ────────────────────────────────────────────────────────

  function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  return { register, login, logout, isLoggedIn, requireAuth, redirectIfLoggedIn };
})();

window.Auth = Auth;
