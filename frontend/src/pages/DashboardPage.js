// src/pages/DashboardPage.js
import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  Alert,
  CircularProgress,
  Chip
} from "@mui/material";
import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [moves, setMoves] = useState([]);
  const [appointments, setAppointments] = useState([]);

  const todayStr = new Date().toISOString().slice(0, 10);

  const loadData = async () => {
    setLoading(true);
    setError("");

    try {
      const movesRes = await apiClient.get("/moves");
      setMoves(movesRes.data || []);
    } catch (err) {
      console.error("Error loading moves:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load data.";
      setError(msg);
    }

    try {
      const apptRes = await apiClient.get("/appointments");
      setAppointments(apptRes.data || []);
    } catch (err) {
      console.error("Error loading appointments:", err);
    }

    setLoading(false);
  };

  useEffect(() => {
    loadData();
  }, []);

  const totalMoves = moves.length;
  const activeMoves = moves.filter((m) => m.status !== "done").length;
  const completedMoves = moves.filter((m) => m.status === "done").length;

  const upcomingAppointmentsCount = appointments.filter((a) => {
    if (!a.apt_date) return false;
    return a.status === "scheduled" && a.apt_date >= todayStr;
  }).length;

  const todayAppointments = appointments.filter(
    (a) => a.apt_date === todayStr
  );

  const nextMove = (() => {
    const movesWithDate = moves.filter((m) => m.move_date);
    if (movesWithDate.length === 0) return null;

    const today = new Date(todayStr);
    const futureOrToday = movesWithDate.filter((m) => {
      const d = new Date(m.move_date.substring(0, 10));
      return d >= today;
    });

    const pool = futureOrToday.length > 0 ? futureOrToday : movesWithDate;

    const sorted = [...pool].sort((a, b) => {
      const da = new Date(a.move_date.substring(0, 10));
      const db = new Date(b.move_date.substring(0, 10));
      return da - db;
    });

    return sorted[0] || null;
  })();

  const formatMoveStatus = (status) => {
    switch (status) {
      case "planned":
        return "Planned";
      case "packing":
        return "Packing";
      case "in_transit":
        return "In transit";
      case "unpacking":
        return "Unpacking";
      case "done":
        return "Done";
      default:
        return status;
    }
  };

  return (
    <AppLayout title="Dashboard">
      <Box
        sx={{
          maxWidth: 1100,
          mx: "auto",
          mt: 1,
          display: "flex",
          flexDirection: "column",
          gap: 3
        }}
      >
        {loading ? (
          <Box
            sx={{
              display: "flex",
              justifyContent: "center",
              mt: 6
            }}
          >
            <CircularProgress />
          </Box>
        ) : (
          <>
            {error && (
              <Alert severity="error" sx={{ mb: 1 }}>
                {error}
              </Alert>
            )}

            <Paper
              sx={{
                p: 3,
                borderRadius: 3,
                bgcolor: "rgba(15,23,42,0.9)",
                border: "1px solid #111827",
                display: "flex",
                flexDirection: "column",
                gap: 2
              }}
            >
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                Dashboard
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Overview of your moves and appointments at a glance.
              </Typography>

              {nextMove ? (
                <Box
                  sx={{
                    mt: 2,
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    p: 2,
                    borderRadius: 2,
                    bgcolor: "rgba(15,23,42,0.9)",
                    border: "1px solid #1f2937"
                  }}
                >
                  <Box>
                    <Typography
                      variant="subtitle1"
                      sx={{ fontWeight: 600, color: "#E5E7EB" }}
                    >
                      Your next move: {nextMove.title}
                    </Typography>
                    <Typography
                      variant="body2"
                      sx={{ mt: 0.5, color: "text.secondary" }}
                    >
                      Move date:{" "}
                      {nextMove.move_date
                        ? nextMove.move_date.substring(0, 10)
                        : "Not set"}
                    </Typography>
                  </Box>
                  <Chip
                    label={formatMoveStatus(nextMove.status)}
                    color="primary"
                    variant="filled"
                    sx={{ fontSize: 12 }}
                  />
                </Box>
              ) : (
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  You do not have any moves yet. Create one on the Moves page.
                </Typography>
              )}
            </Paper>

            <Box
              sx={{
                display: "grid",
                gridTemplateColumns: {
                  xs: "1fr",
                  sm: "repeat(2, minmax(0, 1fr))",
                  md: "repeat(4, minmax(0, 1fr))"
                },
                gap: 2
              }}
            >
              <Paper
                sx={{
                  p: 2.5,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827"
                }}
              >
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{ mb: 1 }}
                >
                  Total moves
                </Typography>
                <Typography variant="h5" sx={{ fontWeight: 700 }}>
                  {totalMoves}
                </Typography>
              </Paper>
              <Paper
                sx={{
                  p: 2.5,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827"
                }}
              >
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{ mb: 1 }}
                >
                  Active moves
                </Typography>
                <Typography variant="h5" sx={{ fontWeight: 700 }}>
                  {activeMoves}
                </Typography>
              </Paper>
              <Paper
                sx={{
                  p: 2.5,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827"
                }}
              >
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{ mb: 1 }}
                >
                  Moves completed
                </Typography>
                <Typography variant="h5" sx={{ fontWeight: 700 }}>
                  {completedMoves}
                </Typography>
              </Paper>
              <Paper
                sx={{
                  p: 2.5,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827"
                }}
              >
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{ mb: 1 }}
                >
                  Upcoming appointments
                </Typography>
                <Typography variant="h5" sx={{ fontWeight: 700 }}>
                  {upcomingAppointmentsCount}
                </Typography>
              </Paper>
            </Box>

            <Box
              sx={{
                display: "grid",
                gridTemplateColumns: {
                  xs: "1fr",
                  md: "2fr 1fr"
                },
                gap: 2.5,
                mb: 4
              }}
            >
              <Paper
                sx={{
                  p: 3,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827",
                  minHeight: 220,
                  display: "flex",
                  flexDirection: "column",
                  gap: 1.5
                }}
              >
                <Typography variant="h6" sx={{ fontWeight: 600 }}>
                  Your moves
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  High-level overview of all moves
                </Typography>

                <Box sx={{ mt: 2, display: "flex", flexDirection: "column", gap: 1 }}>
                  {moves.length === 0 ? (
                    <Typography variant="body2" color="text.secondary">
                      No moves yet. Create your first move to see it here.
                    </Typography>
                  ) : (
                    moves.map((m) => (
                      <Box
                        key={m.id}
                        sx={{
                          p: 1.5,
                          borderRadius: 2,
                          bgcolor: "#020617",
                          border: "1px solid #111827",
                          display: "flex",
                          justifyContent: "space-between",
                          alignItems: "center"
                        }}
                      >
                        <Box>
                          <Typography
                            variant="body2"
                            sx={{ fontWeight: 600, color: "#E5E7EB" }}
                          >
                            {m.title}
                          </Typography>
                          <Typography
                            variant="caption"
                            color="text.secondary"
                            sx={{ display: "block", mt: 0.5 }}
                          >
                            Move date:{" "}
                            {m.move_date ? m.move_date.substring(0, 10) : "Not set"}
                          </Typography>
                        </Box>
                        <Chip
                          label={formatMoveStatus(m.status)}
                          size="small"
                          sx={{ fontSize: 11 }}
                        />
                      </Box>
                    ))
                  )}
                </Box>
              </Paper>

              <Paper
                sx={{
                  p: 3,
                  borderRadius: 3,
                  bgcolor: "#020617",
                  border: "1px solid #111827",
                  minHeight: 220,
                  display: "flex",
                  flexDirection: "column",
                  gap: 1.5
                }}
              >
                <Typography variant="h6" sx={{ fontWeight: 600 }}>
                  Today
                </Typography>
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{ mb: 2 }}
                >
                  {todayStr}
                </Typography>

                {todayAppointments.length === 0 ? (
                  <Typography variant="body2" color="text.secondary">
                    No appointments scheduled for today.
                  </Typography>
                ) : (
                  <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5 }}>
                    {todayAppointments.map((a) => (
                      <Box
                        key={a.id}
                        sx={{
                          p: 1.5,
                          borderRadius: 2,
                          bgcolor: "#020617",
                          border: "1px solid #111827"
                        }}
                      >
                        <Typography
                          variant="body2"
                          sx={{ fontWeight: 600, color: "#E5E7EB" }}
                        >
                          {a.title}
                        </Typography>
                        <Typography
                          variant="caption"
                          color="text.secondary"
                          sx={{ display: "block", mt: 0.5 }}
                        >
                          Time: {a.apt_time ? a.apt_time.substring(0, 5) : "—"}
                        </Typography>
                        {a.person && (
                          <Typography
                            variant="caption"
                            color="text.secondary"
                            sx={{ display: "block", mt: 0.5 }}
                          >
                            With: {a.person}
                          </Typography>
                        )}
                      </Box>
                    ))}
                  </Box>
                )}
              </Paper>
            </Box>
          </>
        )}
      </Box>
    </AppLayout>
  );
}

export default DashboardPage;
