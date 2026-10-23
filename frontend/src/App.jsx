
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';

import LoginPage from './pages/LoginPage';
import AboutDeveloperPage from './pages/AboutDeveloperPage';
import ForgotPasswordPage from './pages/ForgotPasswordPage';
import ResetPasswordPage from './pages/ResetPasswordPage';

import CommonDashboardPage from './pages/CommonDashboardPage';
import SportTeacherPage from './pages/SportTeacherPage';
import DistrictManagerPage from './pages/DistrictManagerPage';
import ZoneManagerPage from './pages/ZoneManagerPage';
import TalentAdminPage from './pages/TalentAdminPage';
import SchoolRegistrationPage from './pages/SchoolRegistrationPage';
import StudentPage from './pages/StudentPage';

import './App.css';

const ProtectedRoute = ({ children, requiredRole }) => {
  const { isAuthenticated, authReady, user } = useAuth();

  if (!authReady) {
    return (
      <div style={{ padding: '2rem', textAlign: 'center' }}>
        Checking session...
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user?.role !== requiredRole) {
    return <Navigate to="/login" replace />;
  }

  return children;
};

const AppRoutes = () => {
  const { isAuthenticated, authReady, user } = useAuth();

  if (!authReady) {
    return (
      <div style={{ padding: '2rem', textAlign: 'center' }}>
        Checking session...
      </div>
    );
  }

  return (
    <div className="app-shell">
      <main className="app-main">
        <Routes>
      {/* Public Routes */}
      <Route path="/login" element={<LoginPage />} />
      <Route path="/about-developer" element={<AboutDeveloperPage />} />

      <Route
        path="/forgot-password"
        element={<ForgotPasswordPage />}
      />

      <Route
        path="/reset-password"
        element={<ResetPasswordPage />}
      />

      <Route
        path="/register-school"
        element={<SchoolRegistrationPage />}
      />

      {/* Dashboard Routes */}

      <Route
        path="/dashboard/talent-admin"
        element={
          <ProtectedRoute requiredRole="talent_admin">
            <TalentAdminPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/region-manager"
        element={
          <ProtectedRoute requiredRole="region_manager">
            <CommonDashboardPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/zone-manager"
        element={
          <ProtectedRoute requiredRole="zone_manager">
            <ZoneManagerPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/district-manager"
        element={
          <ProtectedRoute requiredRole="district_manager">
            <DistrictManagerPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/ward-manager"
        element={
          <ProtectedRoute requiredRole="ward_manager">
            <CommonDashboardPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/head-teacher"
        element={
          <ProtectedRoute requiredRole="head_teacher">
            <CommonDashboardPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/sport-teacher"
        element={
          <ProtectedRoute requiredRole="sport_teacher">
            <SportTeacherPage />
          </ProtectedRoute>
        }
      />

      <Route
        path="/dashboard/student"
        element={
          <ProtectedRoute requiredRole="student">
            <StudentPage />
          </ProtectedRoute>
        }
      />

      {/* Home Route */}

      <Route
        path="/"
        element={
          isAuthenticated ? (
            <Navigate
              to={`/dashboard/${user?.role.replace('_', '-')}`}
              replace
            />
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      {/* Unknown Route */}

      <Route
        path="*"
        element={<Navigate to="/" replace />}
      />
        </Routes>
      </main>

      <footer className="app-global-footer">
        © 2026 Design and Developed by <strong>Eng Isack Seba</strong>. All rights reserved.
      </footer>
    </div>
  );
};

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;

