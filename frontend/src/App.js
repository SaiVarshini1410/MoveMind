import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";

import LoginPage from "./pages/auth/LoginPage";
import RegisterPage from "./pages/auth/RegisterPage";
import DashboardPage from "./pages/DashboardPage";
import MovesPage from "./pages/MovesPage";
import AddressesPage from "./pages/AddressesPage";
import RoomsPage from "./pages/RoomsPage";
import BoxesPage from "./pages/BoxesPage";
import ScanBoxPage from "./pages/ScanBoxPage";
import AppointmentsPage from "./pages/AppointmentsPage";
import DocumentsPage from "./pages/DocumentsPage";
import UtilitiesPage from "./pages/UtilitiesPage";
import { getToken } from "./utils/auth";

function RequireAuth({ children }) {
  const token = getToken();
  if (!token) {
    return <Navigate to="/login" replace />;
  }
  return children;
}

function App() {
  const token = getToken();

  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      <Route
        path="/dashboard"
        element={
          <RequireAuth>
            <DashboardPage />
          </RequireAuth>
        }
      />

      <Route
        path="/moves"
        element={
          <RequireAuth>
            <MovesPage />
          </RequireAuth>
        }
      />

      <Route
        path="/addresses"
        element={
          <RequireAuth>
            <AddressesPage />
          </RequireAuth>
        }
      />

      <Route
        path="/moves/:moveId/rooms"
        element={
          <RequireAuth>
            <RoomsPage />
          </RequireAuth>
        }
      />

      <Route
        path="/moves/:moveId/rooms/:roomName/boxes"
        element={
          <RequireAuth>
            <BoxesPage />
          </RequireAuth>
        }
      />

      <Route
        path="/scan/:labelCode"
        element={
          <RequireAuth>
            <ScanBoxPage />
          </RequireAuth>
        }
      />

      <Route
        path="/appointments"
        element={
          <RequireAuth>
            <AppointmentsPage />
          </RequireAuth>
        }
      />

      <Route
        path="/moves/:moveId/documents"
        element={
          <RequireAuth>
            <DocumentsPage />
          </RequireAuth>
        }
      />

      <Route
        path="/utilities"
        element={
          <RequireAuth>
            <UtilitiesPage />
          </RequireAuth>
        }
      />

      <Route
        path="/"
        element={
          token ? (
            <Navigate to="/dashboard" replace />
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route
        path="*"
        element={
          token ? (
            <Navigate to="/dashboard" replace />
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />
    </Routes>
  );
}

export default App;
