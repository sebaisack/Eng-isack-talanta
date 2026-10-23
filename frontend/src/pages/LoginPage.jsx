import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import '../styles/login.css';
import logo from '../assets/Logo1.png';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState('');
  const [errorHint, setErrorHint] = useState('');
  const [loading, setLoading] = useState(false);

  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setErrorHint('');

    if (!username.trim() || !password) {
      setError('Please enter both username and password.');
      return;
    }

    setLoading(true);

    try {
      const userData = await login(username.trim(), password, rememberMe);
      navigate('/dashboard/' + userData.role.replace('_', '-'));
    } catch (err) {
      console.error('Login error caught in component:', err);

      if (
        err?.message === 'Failed to fetch' ||
        err?.name === 'TypeError' ||
        err?.name === 'AbortError'
      ) {
        setError('Unable to connect to Talanta');
        setErrorHint('Please check your network connection and try again.');
      } else {
        setError(
          err?.message ||
            'Login failed. Please check your credentials and try again.'
        );
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="login-page login-page-premium">
      <div className="login-shell">
        <section className="login-visual" aria-label="About Talanta">
          <div className="login-visual-glow login-visual-glow-one" />
          <div className="login-visual-glow login-visual-glow-two" />

          <div className="login-visual-topline">
            <span className="login-brand-mark" aria-hidden="true">
              <svg viewBox="0 0 24 24"><path d="M12 2.8 14.7 8.3 20.8 9.2 16.4 13.5 17.5 19.6 12 16.7 6.5 19.6 7.6 13.5 3.2 9.2 9.3 8.3 12 2.8Z" /></svg>
            </span>
            <span>TALANTA <small>EDUCATION &amp; TALENT</small></span>
          </div>

          <div className="login-visual-copy">
            <span className="login-eyebrow"><span /> YOUR FUTURE STARTS HERE</span>
            <h1>Every talent<br />deserves a <em>stage.</em></h1>
            <p>Discover potential. Celebrate achievement. Build the next generation of talent through one connected platform.</p>

            <div className="login-feature-list">
              <div className="login-feature-item">
                <span className="login-feature-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m4 12 5 5L20 6" /></svg></span>
                <span><strong>Discover potential</strong><small>Make every student's talent count.</small></span>
              </div>
              <div className="login-feature-item">
                <span className="login-feature-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 3v18M3 12h18" /><circle cx="12" cy="12" r="8.5" /></svg></span>
                <span><strong>Track achievement</strong><small>Follow progress at every level.</small></span>
              </div>
            </div>
          </div>

          <div className="login-visual-bottom">
            <span className="login-status-dot" /> CONNECTING TALENT WITH OPPORTUNITY
            <span className="login-visual-year">EST. FOR TOMORROW</span>
          </div>
        </section>

        <section className="login-content" aria-label="Sign in to Talanta">
          <div className="login-content-inner">
            <div className="login-mobile-brand login-brand-top-right">
              <img src={logo} alt="Conturel Education Networking Initiative" />
            </div>

            <div className="login-heading">
              <span className="login-heading-kicker">WELCOME BACK</span>
              <h2>Sign in to your account<span>.</span></h2>
              <p>Enter your details to continue to your Talanta workspace.</p>
            </div>

            {error && (
              <div className="alert error login-error-message" role="alert">
                <strong>{error}</strong>
                {errorHint && <small>{errorHint}</small>}
              </div>
            )}

            <form onSubmit={handleSubmit} className="auth-form login-premium-form">
              <div className="field-group login-premium-field">
                <label htmlFor="username">Username or Student ID</label>
                <div className="login-input-shell">
                  <svg className="login-input-icon" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="4" /><path d="M4 21v-2a8 8 0 0 1 16 0v2Z" /></svg>
                  <input
                    id="username"
                    type="text"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    autoComplete="username"
                    placeholder="Enter username or Student ID"
                    disabled={loading}
                    required
                  />
                </div>
              </div>

              <div className="field-group login-premium-field">
                <label htmlFor="password">Password</label>
                <div className="login-input-shell password-input-wrapper">
                  <svg className="login-input-icon" viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="10" width="16" height="11" rx="2" /><path d="M8 10V7a4 4 0 0 1 8 0v3" /></svg>
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    autoComplete="current-password"
                    placeholder="Enter your password"
                    disabled={loading}
                    required
                  />
                  <button
                    type="button"
                    className="password-toggle"
                    onClick={() => setShowPassword((current) => !current)}
                    aria-label={showPassword ? 'Hide password' : 'Show password'}
                    title={showPassword ? 'Hide password' : 'Show password'}
                  >
                    {showPassword ? (
                      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z" /><circle cx="12" cy="12" r="2.5" /></svg>
                    ) : (
                      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3l18 18" /><path d="M10.6 6.3A9.9 9.9 0 0 1 12 6c6.5 0 10 6 10 6a18 18 0 0 1-3.2 3.8" /><path d="M6.2 6.8C3.5 8.5 2 12 2 12s3.5 6 10 6c1.5 0 2.8-.3 4-.8" /><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2" /></svg>
                    )}
                  </button>
                </div>
              </div>

              <div className="login-options-row login-premium-options">
                <label className="remember-me">
                  <input
                    type="checkbox"
                    checked={rememberMe}
                    onChange={(e) => setRememberMe(e.target.checked)}
                    disabled={loading}
                  />
                  <span>Remember me</span>
                </label>
                <Link to="/forgot-password" className="forgot-password-link">Forgot password?</Link>
              </div>

              <button type="submit" className="primary-btn login-premium-submit" disabled={loading}>
                <span>{loading ? 'Signing you in...' : 'Sign in to Talanta'}</span>
                {!loading && <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6" /></svg>}
                {loading && <span className="login-spinner" aria-hidden="true" />}
              </button>

              {/* SCHOOL REGISTRATION LINK — HIDDEN FOR NOW
              <div className="login-register-note">
                <span>Managing a school?</span>
                <Link to="/register-school" className="register-school-link">Register your school <span aria-hidden="true">↗</span></Link>
              </div>
              END SCHOOL REGISTRATION LINK COMMENT */}
            </form>

            <div className="login-security-note">
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-11V5l-8-3-8 3v6c0 7 8 11 8 11Z" /><path d="m9 12 2 2 4-4" /></svg>
              <span>Your account and information are protected.</span>
            </div>

            <footer className="login-developer-under-button login-premium-footer">
              © 2026 Designed &amp; developed by{' '}
              <Link to="/about-developer" className="login-developer-link">Eng Isack Seba</Link>
              <span className="login-footer-rights">All rights reserved.</span>
            </footer>
          </div>
        </section>
      </div>
    </main>
  );
}
