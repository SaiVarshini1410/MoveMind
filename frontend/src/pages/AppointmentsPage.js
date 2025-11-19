// src/pages/AppointmentsPage.js
import React, { useEffect, useState, useMemo } from "react";
import {
  Box,
  Typography,
  Paper,
  Button,
  Alert,
  CircularProgress,
  TextField,
  MenuItem,
  Chip,
  IconButton,
  Divider
} from "@mui/material";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import DoneIcon from "@mui/icons-material/Done";

import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

const STATUS_FILTER_OPTIONS = [
  { value: "all", label: "All statuses" },
  { value: "scheduled", label: "Scheduled" },
  { value: "completed", label: "Completed" },
  { value: "cancelled", label: "Cancelled" }
];

const APPOINTMENT_STATUS_OPTIONS = [
  { value: "scheduled", label: "Scheduled" },
  { value: "completed", label: "Completed" },
  { value: "cancelled", label: "Cancelled" }
];

const formatStatus = (value) => {
  const found = APPOINTMENT_STATUS_OPTIONS.find((s) => s.value === value);
  return found ? found.label : value;
};

const formatTime = (t) => {
  if (!t) return "—";
  // "HH:MM:SS" -> "HH:MM"
  return t.substring(0, 5);
};

function AppointmentsPage() {
  const [moves, setMoves] = useState([]);
  const [selectedMoveId, setSelectedMoveId] = useState("");

  const [appointments, setAppointments] = useState([]);

  const [statusFilter, setStatusFilter] = useState("all");
  const [dateFilter, setDateFilter] = useState("");

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [formError, setFormError] = useState("");

  const [editingAppointment, setEditingAppointment] = useState(null);

  const [form, setForm] = useState({
    title: "",
    apt_date: "",
    apt_time: "",
    person: "",
    contact_person: "",
    contact_phone: "",
    description: "",
    status: "scheduled"
  });

  // Load all moves once
  useEffect(() => {
    const loadMoves = async () => {
      setLoading(true);
      setError("");
      try {
        const res = await apiClient.get("/moves");
        const data = res.data || [];
        setMoves(data);

        if (!selectedMoveId && data.length > 0) {
          setSelectedMoveId(String(data[0].id));
        }
      } catch (err) {
        console.error("Error loading moves:", err);
        const msg =
          err.response?.data?.message ||
          err.response?.data?.error ||
          "Failed to load moves.";
        setError(msg);
      } finally {
        setLoading(false);
      }
    };

    loadMoves();
  }, []); // only once

  // Load appointments whenever selectedMoveId / filters change
  useEffect(() => {
    const loadAppointments = async () => {
      if (!selectedMoveId) {
        setAppointments([]);
        return;
      }

      setLoading(true);
      setError("");

      try {
        let url = `/moves/${selectedMoveId}/appointments`;
        const params = [];
        if (statusFilter !== "all") params.push(`status=${statusFilter}`);
        if (dateFilter) params.push(`date=${dateFilter}`);
        if (params.length) url += `?${params.join("&")}`;

        const res = await apiClient.get(url);
        setAppointments(res.data || []);
      } catch (err) {
        console.error("Error loading appointments:", err);
        const msg =
          err.response?.data?.message ||
          err.response?.data?.error ||
          "Failed to load appointments.";
        setError(msg);
      } finally {
        setLoading(false);
      }
    };

    loadAppointments();
  }, [selectedMoveId, statusFilter, dateFilter]);

  const selectedMove = useMemo(
    () => moves.find((m) => String(m.id) === String(selectedMoveId)) || null,
    [moves, selectedMoveId]
  );

  const resetForm = () => {
    setEditingAppointment(null);
    setFormError("");
    setForm({
      title: "",
      apt_date: "",
      apt_time: "",
      person: "",
      contact_person: "",
      contact_phone: "",
      description: "",
      status: "scheduled"
    });
  };

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSelectMove = (e) => {
    setSelectedMoveId(e.target.value);
    // also reset form + editing state when switching moves
    resetForm();
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setFormError("");

    if (!selectedMoveId) {
      setFormError("Please select a move first.");
      return;
    }

    const { title, apt_date, apt_time, status } = form;
    if (!title || !apt_date || !apt_time) {
      setFormError("Title, date, and time are required.");
      return;
    }

    if (!APPOINTMENT_STATUS_OPTIONS.find((s) => s.value === status)) {
      setFormError("Invalid status.");
      return;
    }

    const payload = {
      title: form.title,
      description: form.description || null,
      person: form.person || null,
      apt_date: form.apt_date,
      apt_time: form.apt_time,
      contact_person: form.contact_person || null,
      contact_phone: form.contact_phone || null,
      status: form.status
    };

    setSaving(true);
    try {
      if (editingAppointment) {
        await apiClient.patch(
          `/appointments/${editingAppointment.id}`,
          payload
        );
      } else {
        await apiClient.post(`/moves/${selectedMoveId}/appointments`, payload);
      }
      // reload list + reset form
      const res = await apiClient.get(
        `/moves/${selectedMoveId}/appointments`
      );
      setAppointments(res.data || []);
      resetForm();
    } catch (err) {
      console.error("Error saving appointment:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save appointment.";
      setFormError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (appt) => {
    setEditingAppointment(appt);
    setFormError("");

    setForm({
      title: appt.title || "",
      apt_date: appt.apt_date ? appt.apt_date.substring(0, 10) : "",
      apt_time: appt.apt_time ? appt.apt_time.substring(0, 5) : "",
      person: appt.person || "",
      contact_person: appt.contact_person || "",
      contact_phone: appt.contact_phone || "",
      description: appt.description || "",
      status: appt.status || "scheduled"
    });
  };

  const handleDelete = async (appt) => {
    const ok = window.confirm(
      `Delete appointment "${appt.title}" on ${appt.apt_date}?`
    );
    if (!ok) return;

    try {
      await apiClient.delete(`/appointments/${appt.id}`);
      // reload
      const res = await apiClient.get(
        `/moves/${selectedMoveId}/appointments`
      );
      setAppointments(res.data || []);
    } catch (err) {
      console.error("Error deleting appointment:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete appointment.";
      alert(msg);
    }
  };

  const handleMarkCompleted = async (appt) => {
    try {
      await apiClient.patch(`/appointments/${appt.id}`, {
        status: "completed"
      });
      const res = await apiClient.get(
        `/moves/${selectedMoveId}/appointments`
      );
      setAppointments(res.data || []);
    } catch (err) {
      console.error("Error marking completed:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to update status.";
      alert(msg);
    }
  };

  // Group appointments by date for the receipt-style list
  const groupedByDate = useMemo(() => {
    const groups = {};
    appointments.forEach((a) => {
      const key = a.apt_date ? a.apt_date.substring(0, 10) : "No date";
      if (!groups[key]) groups[key] = [];
      groups[key].push(a);
    });
    // sort by date ascending
    return Object.entries(groups).sort(([d1], [d2]) =>
      d1.localeCompare(d2)
    );
  }, [appointments]);

  return (
    <AppLayout title="Appointments">
      {/* Page header */}
      <Box sx={{ mb: 3 }}>
        <Typography variant="h4" gutterBottom>
          Appointments
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Track inspections, utility visits, walkthroughs, and other events
          for each move.
        </Typography>
      </Box>

      {/* Top filters / move selector */}
      <Paper
        sx={{
          p: 2,
          mb: 3,
          bgcolor: "#020617",
          borderRadius: 2,
          border: "1px solid #111827",
          display: "flex",
          flexWrap: "wrap",
          gap: 2
        }}
      >
        <TextField
          select
          label="Move"
          value={selectedMoveId}
          onChange={handleSelectMove}
          size="small"
          sx={{ minWidth: 220 }}
        >
          {moves.length === 0 ? (
            <MenuItem value="">No moves yet</MenuItem>
          ) : (
            moves.map((m) => (
              <MenuItem key={m.id} value={m.id}>
                {m.title}
              </MenuItem>
            ))
          )}
        </TextField>

        <TextField
          select
          label="Status filter"
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          size="small"
          sx={{ minWidth: 160 }}
        >
          {STATUS_FILTER_OPTIONS.map((opt) => (
            <MenuItem key={opt.value} value={opt.value}>
              {opt.label}
            </MenuItem>
          ))}
        </TextField>

        <TextField
          label="Date (optional)"
          type="date"
          size="small"
          InputLabelProps={{ shrink: true }}
          value={dateFilter}
          onChange={(e) => setDateFilter(e.target.value)}
          sx={{ minWidth: 160 }}
        />

        <Box sx={{ flexGrow: 1 }} />

        {selectedMove && (
          <Box sx={{ alignSelf: "center" }}>
            <Typography variant="body2" color="text.secondary">
              Viewing appointments for:{" "}
              <strong>{selectedMove.title}</strong>
            </Typography>
          </Box>
        )}
      </Paper>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {/* New / edit appointment form */}
      <Paper
        sx={{
          p: 2,
          mb: 3,
          bgcolor: "#020617",
          borderRadius: 2,
          border: "1px solid #111827",
          maxWidth: 900,
          mx: "auto"
        }}
      >
        <Box
          component="form"
          onSubmit={handleSave}
          sx={{
            display: "flex",
            flexDirection: "column",
            gap: 2
          }}
        >
          <Box
            sx={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center"
            }}
          >
            <Typography variant="subtitle1">
              {editingAppointment
                ? "Edit appointment"
                : "Add a new appointment"}
            </Typography>
            {editingAppointment && (
              <Button
                size="small"
                onClick={resetForm}
                disabled={saving}
              >
                Cancel edit
              </Button>
            )}
          </Box>

          {formError && (
            <Alert severity="error" sx={{ mb: 1 }}>
              {formError}
            </Alert>
          )}

          <Box
            sx={{
              display: "grid",
              gridTemplateColumns: {
                xs: "1fr",
                sm: "2fr 1fr 1fr"
              },
              gap: 2
            }}
          >
            <TextField
              label="Title *"
              name="title"
              value={form.title}
              onChange={handleFormChange}
              fullWidth
            />
            <TextField
              label="Date *"
              type="date"
              name="apt_date"
              value={form.apt_date}
              onChange={handleFormChange}
              InputLabelProps={{ shrink: true }}
              fullWidth
            />
            <TextField
              label="Time *"
              type="time"
              name="apt_time"
              value={form.apt_time}
              onChange={handleFormChange}
              InputLabelProps={{ shrink: true }}
              fullWidth
            />
          </Box>

          <Box
            sx={{
              display: "grid",
              gridTemplateColumns: {
                xs: "1fr",
                sm: "1fr 1fr"
              },
              gap: 2
            }}
          >
            <TextField
              label="Appointment with (company / role)"
              name="person"
              value={form.person}
              onChange={handleFormChange}
              fullWidth
            />
            <TextField
              select
              label="Status"
              name="status"
              value={form.status}
              onChange={handleFormChange}
              fullWidth
            >
              {APPOINTMENT_STATUS_OPTIONS.map((s) => (
                <MenuItem key={s.value} value={s.value}>
                  {s.label}
                </MenuItem>
              ))}
            </TextField>
          </Box>

          <Box
            sx={{
              display: "grid",
              gridTemplateColumns: {
                xs: "1fr",
                sm: "1fr 1fr"
              },
              gap: 2
            }}
          >
            <TextField
              label="Contact person"
              name="contact_person"
              value={form.contact_person}
              onChange={handleFormChange}
              fullWidth
            />
            <TextField
              label="Contact phone"
              name="contact_phone"
              value={form.contact_phone}
              onChange={handleFormChange}
              fullWidth
            />
          </Box>

          <TextField
            label="Description / notes"
            name="description"
            value={form.description}
            onChange={handleFormChange}
            fullWidth
            multiline
            minRows={2}
          />

          <Box sx={{ display: "flex", justifyContent: "flex-end", mt: 1 }}>
            <Button
              type="submit"
              variant="contained"
              disabled={saving}
            >
              {saving
                ? "Saving..."
                : editingAppointment
                ? "Save changes"
                : "Add appointment"}
            </Button>
          </Box>
        </Box>
      </Paper>

      {/* Appointments list (timeline / receipt style) */}
      {loading ? (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 3 }}>
          <CircularProgress />
        </Box>
      ) : (
        <Box sx={{ maxWidth: 900, mx: "auto", mb: 6 }}>
          {appointments.length === 0 ? (
            <Alert severity="info">
              No appointments found for this move and filter.
            </Alert>
          ) : (
            groupedByDate.map(([dateKey, list]) => (
              <Paper
                key={dateKey}
                sx={{
                  mb: 2,
                  p: 2,
                  bgcolor: "#020617",
                  borderRadius: 2,
                  border: "1px solid #111827"
                }}
              >
                <Typography
                  variant="subtitle2"
                  sx={{ mb: 1, color: "#9CA3AF", fontWeight: 600 }}
                >
                  {dateKey}
                </Typography>
                <Divider sx={{ mb: 1 }} />

                {list.map((appt, idx) => (
                  <Box key={appt.id}>
                    <Box
                      sx={{
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "flex-start",
                        gap: 2,
                        py: 1
                      }}
                    >
                      {/* Left side: time + title + details */}
                      <Box sx={{ flex: 1, minWidth: 0 }}>
                        <Typography
                          variant="body2"
                          sx={{ fontWeight: 600, color: "#F9FAFB" }}
                        >
                          {formatTime(appt.apt_time)} — {appt.title}
                        </Typography>
                        {(appt.person ||
                          appt.contact_person ||
                          appt.contact_phone) && (
                          <Typography
                            variant="body2"
                            sx={{ color: "text.secondary", mt: 0.25 }}
                          >
                            {appt.person && `Person: ${appt.person}  `}
                            {appt.contact_person &&
                              ` | Contact: ${appt.contact_person}`}
                            {appt.contact_phone &&
                              ` (${appt.contact_phone})`}
                          </Typography>
                        )}
                        {appt.description && (
                          <Typography
                            variant="body2"
                            sx={{
                              color: "text.secondary",
                              mt: 0.25
                            }}
                          >
                            {appt.description}
                          </Typography>
                        )}
                      </Box>

                      {/* Right side: status chip + actions */}
                      <Box
                        sx={{
                          display: "flex",
                          flexDirection: "column",
                          alignItems: "flex-end",
                          gap: 0.5
                        }}
                      >
                        <Chip
                          label={formatStatus(appt.status)}
                          size="small"
                        />

                        <Box
                          sx={{
                            display: "flex",
                            alignItems: "center",
                            gap: 0.5
                          }}
                        >
                          {appt.status === "scheduled" && (
                            <Button
                              size="small"
                              startIcon={<DoneIcon />}
                              onClick={() => handleMarkCompleted(appt)}
                            >
                              Complete
                            </Button>
                          )}

                          <IconButton
                            size="small"
                            onClick={() => handleEdit(appt)}
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDelete(appt)}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Box>
                      </Box>
                    </Box>

                    {idx < list.length - 1 && (
                      <Divider sx={{ opacity: 0.4 }} />
                    )}
                  </Box>
                ))}
              </Paper>
            ))
          )}
        </Box>
      )}
    </AppLayout>
  );
}

export default AppointmentsPage;
