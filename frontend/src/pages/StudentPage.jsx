import { useEffect, useState } from 'react';
import { Header, ProfileMenu } from '../components/shared';
import * as apiService from '../services/apiService';
import { useAuth } from '../context/AuthContext';
import logo from '../assets/Logo1.png';
import '../styles/dashboard.css';
import './SportTeacherPage.css';
import './StudentPage.css';

const list = (response) => response?.data?.results || (Array.isArray(response?.data) ? response.data : []);

const NAV_ITEMS = [
  ['home', 'Home'],
  ['results', 'Results'],
  ['announcements', 'Announcements'],
];

export default function StudentPage() {
  const { user, logout } = useAuth();
  const [activeTab, setActiveTab] = useState('home');
  const [announcements, setAnnouncements] = useState([]);
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [navigationOpen, setNavigationOpen] = useState(false);
  const [profileMenuOpen, setProfileMenuOpen] = useState(false);
  const [profileDrawerOpen, setProfileDrawerOpen] = useState(false);
  const [passwordDrawerOpen, setPasswordDrawerOpen] = useState(false);
  const [passwordSubmitting, setPasswordSubmitting] = useState(false);
  const [showProfilePassword, setShowProfilePassword] = useState(false);
  const [showProfilePasswordConfirmation, setShowProfilePasswordConfirmation] = useState(false);
  const [passwordError, setPasswordError] = useState('');
  const [passwordForm, setPasswordForm] = useState({ new_password: '', confirm_pass: '' });

  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true);
        setError('');
        console.log('StudentPage: Starting data load...');

        const [announcementsResponse, resultsResponse] = await Promise.all([
          apiService.getAnnouncements({ is_active: true }).catch(err => {
            console.error('Announcements fetch error:', err);
            return { data: { results: [] } };
          }),
          apiService.getAllResults({}).catch(err => {
            console.error('Results fetch error:', err);
            return { data: { results: [] } };
          }),
        ]);

        const announcementsList = list(announcementsResponse);
        const resultsList = list(resultsResponse);


        console.log('StudentPage: Processed announcements:', announcementsList.length);
        console.log('StudentPage: Processed results:', resultsList.length);

        setAnnouncements(announcementsList);
        setResults(resultsList);
      } catch (err) {
        console.error('StudentPage: Unexpected error:', err);
        setError('Failed to load dashboard. Please refresh the page.');
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  const handleChangePassword = async (e) => {
    e.preventDefault();
    if (passwordForm.new_password !== passwordForm.confirm_pass) {
      setPasswordError('Passwords do not match');
      return;
    }
    setPasswordSubmitting(true);
    setPasswordError('');
    try {
      await apiService.updateUserPassword(user.id, passwordForm.new_password);
      setPasswordForm({ current_password: '', new_password: '', confirm_pass: '' });
      setPasswordDrawerOpen(false);
      setPasswordError('Password changed successfully!');
      setTimeout(() => setPasswordError(''), 3000);
    } catch (err) {
      const errorMessage = err?.response?.data?.detail || err?.response?.data?.password?.[0] || 'Failed to change password';
      setPasswordError(errorMessage);
    } finally {
      setPasswordSubmitting(false);
    }
  };

  const openProfileDrawer = () => {
    setProfileMenuOpen(false);
    setProfileDrawerOpen(true);
  };

  const openChangePasswordDrawer = () => {
    setProfileMenuOpen(false);
    setPasswordDrawerOpen(true);
  };

  const handleLogout = () => {
    setProfileMenuOpen(false);
    logout();
  };

  const totalResults = results.length;
  const passedResults = results.filter((r) => r.status === 'pending').length;
  const failedResults = results.filter((r) => r.status === 'fail').length;
  const totalAnnouncements = announcements.length;
  const successRate = totalResults > 0 ? Math.round((passedResults / totalResults) * 100) : 0;

  return (
    <div className="sport-teacher-page student-page">
      <header className="sport-teacher-app-bar">
        <div className="sport-teacher-brand">
          <img src={logo} alt="Talanta logo" />
          <span>Student Dashboard</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginLeft: 'auto' }}>
          <ProfileMenu
            isOpen={profileMenuOpen}
            onToggle={() => setProfileMenuOpen((open) => !open)}
            onProfile={openProfileDrawer}
            onChangePassword={openChangePasswordDrawer}
            onLogout={handleLogout}
            username={user?.student_id || user?.username}
          />
          <button
            type="button"
            className="sport-teacher-navigation-toggle"
            onClick={() => setNavigationOpen((open) => !open)}
            aria-label="Open navigation menu"
            aria-expanded={navigationOpen}
          >
            <span />
            <span />
            <span />
          </button>
        </div>
      </header>

      <aside
        className={`sport-teacher-navigation student-bootstrap-navigation nav flex-column gap-1 p-2 ${
          navigationOpen ? 'is-open' : ''
        }`}
        aria-label="Student navigation"
      >
        <div className="sport-teacher-navigation-heading px-2 py-2">
          Student Dashboard
        </div>
        {NAV_ITEMS.map(([key, label]) => (
          <button
            type="button"
            key={key}
            className={`btn text-start w-100 student-bootstrap-nav-link ${
              activeTab === key ? 'active' : ''
            }`}
            aria-current={activeTab === key ? 'page' : undefined}
            onClick={() => {
              setActiveTab(key);
              setNavigationOpen(false);
            }}
          >
            {label}
          </button>
        ))}
      </aside>

      <main className="sport-teacher-prototype-content talent-admin-content">
        {error && (
          <div className="talent-admin-alert" style={{ marginBottom: '16px' }}>
            {error}
            <button type="button" onClick={() => setError(null)} aria-label="Dismiss error">
              &times;
            </button>
          </div>
        )}

        {loading && (
          <section className="talent-admin-table-card" style={{ width: 'min(100%, 1100px)', margin: '0 auto' }}>
            <div className="talent-admin-table-header">
              <div>
                <h2 style={{ margin: 0 }}>Student Dashboard</h2>
              </div>
            </div>
            <div style={{ padding: '48px', textAlign: 'center', color: '#64748b' }}>
              Loading your dashboard...
            </div>
          </section>
        )}

        {!loading && (
          <>
            {/* HOME TAB */}
            {activeTab === 'home' && (
              <div style={{ width: 'min(100%, 1100px)', margin: '0 auto' }}>
                {/* Summary Stats */}
                <section className="talent-admin-table-card">
                  <div className="talent-admin-table-header">
                    <div>
                      <h2 style={{ margin: 0 }}>Welcome to Student Dashboard</h2>
                      <p style={{ margin: '8px 0 0 0', color: '#64748b', fontSize: '14px' }}>
                        Overview of your academic performance
                      </p>
                    </div>
                  </div>
                  <div style={{ padding: '24px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '16px' }}>
                    <div style={{ padding: '16px', border: '1px solid #e5e7eb', borderRadius: '8px', backgroundColor: '#f8fafc' }}>
                      <h4 style={{ margin: '0 0 8px 0', fontSize: '14px', color: '#64748b' }}>Total Results</h4>
                      <p style={{ margin: 0, fontSize: '28px', fontWeight: 700, color: '#0f172a' }}>{totalResults}</p>
                    </div>
                    <div style={{ padding: '16px', border: '1px solid #e5e7eb', borderRadius: '8px', backgroundColor: '#f8fafc' }}>
                      <h4 style={{ margin: '0 0 8px 0', fontSize: '14px', color: '#64748b' }}>Passed Results</h4>
                      <p style={{ margin: 0, fontSize: '28px', fontWeight: 700, color: '#15803d' }}>{passedResults}</p>
                    </div>
                    <div style={{ padding: '16px', border: '1px solid #e5e7eb', borderRadius: '8px', backgroundColor: '#f8fafc' }}>
                      <h4 style={{ margin: '0 0 8px 0', fontSize: '14px', color: '#64748b' }}>Failed Results</h4>
                      <p style={{ margin: 0, fontSize: '28px', fontWeight: 700, color: '#991b1b' }}>{failedResults}</p>
                    </div>
                    <div style={{ padding: '16px', border: '1px solid #e5e7eb', borderRadius: '8px', backgroundColor: '#f8fafc' }}>
                      <h4 style={{ margin: '0 0 8px 0', fontSize: '14px', color: '#64748b' }}>Success Rate</h4>
                      <p style={{ margin: 0, fontSize: '28px', fontWeight: 700, color: '#0f172a' }}>{successRate}%</p>
                    </div>
                  </div>
                </section>

                {/* Recent Results */}
                {results.length > 0 && (
                  <section className="talent-admin-table-card" style={{ marginTop: '16px' }}>
                    <div className="talent-admin-table-header">
                      <div>
                        <h3 style={{ margin: 0 }}>Recent Results</h3>
                      </div>
                    </div>
                    <div className="talent-admin-table-wrap">
                      <table className="talent-admin-table">
                        <thead>
                          <tr>
                            <th>Competition</th>
                            <th>Username</th>
                            <th>Marks</th>
                            <th>Grade</th>
                            <th>Status</th>
                            <th>Award</th>
                            <th>Remark</th>
                          </tr>
                        </thead>
                        <tbody>
                          {results.slice(0, 5).map((result) => {
                              const awardStatus = result.award_status || 'none';

                            return (
                              <tr key={result.id}>
                                <td>{result.competition_name || 'Competition'}</td>
                                <td>{result.student_username || user?.student_id || '-'}</td>
                                <td>{result.score ?? 'N/A'}%</td>
                                <td>{result.grade || 'N/A'}</td>
                                <td>
                                  <span
                                    style={{
                                      display: 'inline-block',
                                      padding: '0.25rem 0.6rem',
                                      borderRadius: '4px',
                                      fontSize: '12px',
                                      fontWeight: 600,
                                      background: status === 'fail' ? '#fee2e2' : '#fef3c7',
                                      color: status === 'fail' ? '#991b1b' : '#92400e',
                                    }}
                                  >
                                    {status === 'fail' ? 'Fail' : 'Pending'}
                                  </span>
                                </td>
                                <td>
                                  {awardStatus === 'awarded' ? 'Awarded' : 'None'}
                                </td>
                                <td>{result.remark || '-'}</td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  </section>
                )}

                {/* Recent Announcements */}
                {announcements.length > 0 && (
                  <section className="talent-admin-table-card" style={{ marginTop: '16px' }}>
                    <div className="talent-admin-table-header">
                      <div>
                        <h3 style={{ margin: 0 }}>Recent Announcements</h3>
                      </div>
                    </div>
                    <div style={{ padding: '16px' }}>
                      {announcements.slice(0, 3).map((announcement) => (
                        <div
                          key={announcement.id}
                          style={{
                            marginBottom: '12px',
                            paddingBottom: '12px',
                            borderBottom: '1px solid #e5e7eb',
                          }}
                        >
                          <h4 style={{ margin: '0 0 4px 0', fontSize: '14px', fontWeight: 600 }}>
                            {announcement.title}
                          </h4>
                          <p style={{ margin: '0 0 4px 0', fontSize: '13px', color: '#475569' }}>
                            {announcement.content}
                          </p>
                          <small style={{ color: '#94a3b8', fontSize: '11px' }}>
                            {announcement.scope_display || announcement.scope}
                          </small>
                        </div>
                      ))}
                    </div>
                  </section>
                )}
              </div>
            )}

            {/* RESULTS TAB */}
            {activeTab === 'results' && (() => {
              const schoolResults = results.filter(
                (result) => result.competition_level === 'school'
              );
              const districtResults = results.filter(
                (result) => result.competition_level === 'district'
              );

              const promotionLabel = (result) => {
                const details = Array.isArray(result.details) ? result.details : [];
                if (!details.length) return 'Pending';

                const labels = [...new Set(details.map((detail) => {
                  const value = detail.promotion_status || 'pending';
                  if (value === 'promoted') return 'Promoted';
                  if (value === 'not_promoted') return 'Not Promoted';
                  return 'Pending';
                }))];

                return labels.join(' / ');
              };

              const renderTable = (title, items) => (
                <section
                  className="talent-admin-table-card student-results-card"
                  style={{ width: 'min(100%, 1100px)', margin: '0 auto 24px auto' }}
                >
                  <div className="talent-admin-table-header">
                    <div>
                      <h2 style={{ margin: 0 }}>{title}</h2>
                      <p style={{ margin: '8px 0 0 0', color: '#64748b', fontSize: '14px' }}>
                        {items.length} result{items.length === 1 ? '' : 's'}
                      </p>
                    </div>
                  </div>
                  <div className="talent-admin-table-wrap">
                    <table className="talent-admin-table student-results-table">
                      <thead>
                        <tr>
                          <th>Competition</th>
                          <th>Username</th>
                          <th>Marks</th>
                          <th>Grade</th>
                          <th>Promotion Status</th>
                          <th>Award</th>
                          <th>Remark</th>
                        </tr>
                      </thead>
                      <tbody>
                        {items.length > 0 ? items.map((result) => {
                          const status = result.status || 'pending';
                          const awardStatus = result.award_status || 'none';
                          const details = Array.isArray(result.details) ? result.details : [];
                          const promotionStatuses = details.length
                            ? details.map((detail) => {
                                const scoreValue = detail.percentage_score ?? detail.raw_score;
                                const score = scoreValue == null ? null : Number(scoreValue);

                                if (score !== null && score < 50) return 'Fail';

                                const value = detail.promotion_status || 'pending';
                                if (value === 'promoted') return 'Promoted';
                                if (value === 'not_promoted') return 'Not Promoted';
                                return 'Pending';
                              })
                            : [Number(result.score) < 50 ? 'Fail' : 'Pending'];

                          const promotionStatus = [...new Set(promotionStatuses)].join(' / ');

                          return (
                            <tr key={result.id}>
                              <td>{result.competition_name || 'Competition'}</td>
                              <td>{result.student_username || user?.student_id || '-'}</td>
                              <td>
                                {(() => {
                                  const scores = details
                                    .map((detail) => detail.percentage_score ?? detail.raw_score)
                                    .filter((score) => score !== null && score !== undefined)
                                    .map(Number);
                                  const shownScores = scores.length
                                    ? scores
                                    : result.score !== null && result.score !== undefined
                                      ? [Number(result.score)]
                                      : [];
                                  return shownScores.length
                                    ? shownScores.map((score) => `${score}%`).join(' / ')
                                    : 'N/A';
                                })()}
                              </td>
                              <td>
                                {(() => {
                                  const scores = details
                                    .map((detail) => detail.percentage_score ?? detail.raw_score)
                                    .filter((score) => score !== null && score !== undefined)
                                    .map(Number);
                                  const shownScores = scores.length
                                    ? scores
                                    : result.score !== null && result.score !== undefined
                                      ? [Number(result.score)]
                                      : [];
                                  const gradeForScore = (score) => {
                                    if (score >= 90) return 'A+';
                                    if (score >= 75) return 'A';
                                    if (score >= 60) return 'B+';
                                    if (score >= 50) return 'B';
                                    if (score >= 40) return 'C';
                                    if (score >= 30) return 'D';
                                    if (score >= 20) return 'E';
                                    return 'F';
                                  };
                                  return shownScores.length
                                    ? shownScores.map(gradeForScore).join(' / ')
                                    : 'N/A';
                                })()}
                              </td>
                              <td>
                                <span className={`student-promotion-status ${
                                  promotionStatus.toLowerCase().includes('fail')
                                    ? 'is-fail'
                                    : promotionStatus.toLowerCase().includes('not promoted')
                                      ? 'is-not-promoted'
                                      : promotionStatus.toLowerCase().includes('promoted')
                                        ? 'is-promoted'
                                        : 'is-pending'
                                }`}>
                                  {promotionStatus}
                                </span>
                              </td>
                              <td>
                                {details.length > 0
                                  ? [...new Set(details.map((detail) =>
                                      detail.award_status === 'awarded' ? 'Awarded' : 'None'
                                    ))].join(' / ')
                                  : (awardStatus === 'awarded' ? 'Awarded' : 'None')}
                              </td>
                              <td>
                                {details.length > 0
                                  ? [...new Set(details.map((detail) => {
                                      if (detail.remark) return detail.remark;
                                      const value = detail.percentage_score ?? detail.raw_score;
                                      if (value == null) return '-';
                                      const score = Number(value);
                                      if (score >= 90) return 'Excellent';
                                      if (score >= 75) return 'Very Good';
                                      if (score >= 50) return 'Good';
                                      return 'Poor';
                                    }))].join(' / ')
                                  : (result.remark || '-')}
                              </td>
                            </tr>
                          );
                        }) : (
                          <tr>
                            <td colSpan="7" style={{ textAlign: 'center', padding: '24px', color: '#94a3b8' }}>
                              No results found yet.
                            </td>
                          </tr>
                        )}
                      </tbody>
                    </table>
                  </div>
                </section>
              );

              return (
                <div>
                  {renderTable('School Results', schoolResults)}
                  {renderTable('District Results', districtResults)}
                </div>
              );
            })()}

            {/* ANNOUNCEMENTS TAB */}
            {activeTab === 'announcements' && (
              <section className="talent-admin-table-card" style={{ width: 'min(100%, 1100px)', margin: '0 auto' }}>
                <div className="talent-admin-table-header">
                  <div>
                    <h2 style={{ margin: 0 }}>Announcements</h2>
                    <p style={{ margin: '8px 0 0 0', color: '#64748b', fontSize: '14px' }}>
                      Important messages and updates
                    </p>
                  </div>
                </div>
                <div className="talent-admin-table-wrap">
                  {announcements.length > 0 ? (
                    <div style={{ padding: '16px' }}>
                      {announcements.map((announcement) => (
                        <div
                          key={announcement.id}
                          style={{
                            marginBottom: '16px',
                            paddingBottom: '16px',
                            borderBottom: '1px solid #e5e7eb',
                          }}
                        >
                          <h4 style={{ margin: '0 0 8px 0', fontSize: '15px', fontWeight: 600 }}>
                            {announcement.title}
                          </h4>
                          <p style={{ margin: '0 0 8px 0', fontSize: '14px', color: '#475569' }}>
                            {announcement.content}
                          </p>
                          <small style={{ color: '#94a3b8', fontSize: '12px' }}>
                            {announcement.scope_display || announcement.scope}
                          </small>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div style={{ padding: '24px', textAlign: 'center', color: '#94a3b8' }}>
                      No announcements available.
                    </div>
                  )}
                </div>
              </section>
            )}
          </>
        )}
      </main>

      {/* PROFILE DRAWER */}
      {profileDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop" aria-label="Close profile" onClick={() => setProfileDrawerOpen(false)} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer" style={{ '--drawer-width': '480px' }} aria-label="Profile details">
            <div className="sport-teacher-search-drawer-header">
              <h2>Profile</h2>
              <button type="button" onClick={() => setProfileDrawerOpen(false)} aria-label="Close profile">&times;</button>
            </div>
            <div className="sport-teacher-profile-details">
              <div><span>Student ID:</span><strong>{user?.student_id || user?.username || '-'}</strong></div>
              <div><span>First name:</span><strong>{user?.first_name || '-'}</strong></div>
              <div><span>Last name:</span><strong>{user?.last_name || '-'}</strong></div>
              <div><span>Email:</span><strong>{user?.email || '-'}</strong></div>
              <div><span>Role:</span><strong>{user?.role || '-'}</strong></div>
            </div>
          </aside>
        </>
      )}

      {/* CHANGE PASSWORD DRAWER */}
      {passwordDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop" aria-label="Close change password" onClick={() => setPasswordDrawerOpen(false)} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer" style={{ '--drawer-width': '480px' }} aria-label="Change password">
            <div className="sport-teacher-search-drawer-header">
              <h2>Change password</h2>
              <button type="button" onClick={() => setPasswordDrawerOpen(false)} aria-label="Close change password">&times;</button>
            </div>
            {passwordError && <div style={{ padding: '16px', color: '#991b1b', background: passwordError.includes('successfully') ? '#dcfce7' : '#fee2e2' }}>{passwordError}</div>}
            <form onSubmit={handleChangePassword} className="sport-teacher-profile-form">
              <label>
                New password
                <span className="sport-teacher-password-control">
                  <input type={showProfilePassword ? 'text' : 'password'} value={passwordForm.new_password} onChange={(e) => setPasswordForm({ ...passwordForm, new_password: e.target.value })} minLength="8" required />
                  <button type="button" onClick={() => setShowProfilePassword((visible) => !visible)} aria-label={showProfilePassword ? 'Hide new password' : 'Show new password'}>
                    {showProfilePassword ? '👁️' : '👁️‍🗨️'}
                  </button>
                </span>
              </label>
              <label>
                Confirm password
                <span className="sport-teacher-password-control">
                  <input type={showProfilePasswordConfirmation ? 'text' : 'password'} value={passwordForm.confirm_pass} onChange={(e) => setPasswordForm({ ...passwordForm, confirm_pass: e.target.value })} minLength="8" required />
                  <button type="button" onClick={() => setShowProfilePasswordConfirmation((visible) => !visible)} aria-label={showProfilePasswordConfirmation ? 'Hide password confirmation' : 'Show password confirmation'}>
                    {showProfilePasswordConfirmation ? '👁️' : '👁️‍🗨️'}
                  </button>
                </span>
              </label>
              <button type="submit" className="sport-teacher-profile-submit" disabled={passwordSubmitting}>{passwordSubmitting ? 'Saving...' : 'Save password'}</button>
            </form>
          </aside>
        </>
      )}
    </div>
  );
}
