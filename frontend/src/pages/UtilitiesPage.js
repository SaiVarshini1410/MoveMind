import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  Button,
  Alert,
  CircularProgress,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  IconButton,
  Chip
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";

import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

const STATUS_OPTIONS = [
  { value: "planned", label: "Planned" },
  { value: "requested", label: "Requested" },
  { value: "confirmed", label: "Confirmed" },
  { value: "active", label: "Active" },
  { value: "cancelled", label: "Cancelled" }
];

const TYPE_LABELS = {
  electricity: "Electricity",
  gas: "Gas",
  water: "Water",
  internet: "Internet",
  trash: "Trash",
  other: "Other"
};

function formatStatus(value) {
  const found = STATUS_OPTIONS.find((s) => s.value === value);
  return found ? found.label : value;
}

function UtilitiesPage() {
  const [moves, setMoves] = useState([]);
  const [utilities, setUtilities] = useState([]);
  const [moveUtilities, setMoveUtilities] = useState([]);

  const [selectedMoveId, setSelectedMoveId] = useState("");

  const [loading, setLoading] = useState(true);
  const [tableLoading, setTableLoading] = useState(false);
  const [error, setError] = useState("");

  const [dialogOpen, setDialogOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [dialogError, setDialogError] = useState("");
  const [editingMu, setEditingMu] = useState(null);

  const [form, setForm] = useState({
    move_id: "",
    utility_id: "",
    account_number: "",
    stop_date: "",
    start_date: "",
    status: "planned"
  });

  const loadInitial = async () => {
    setLoading(true);
    setError("");
    try {
      const [movesRes, utilitiesRes] = await Promise.all([
        apiClient.get("/moves"),
        apiClient.get("/utilities")
      ]);
      const movesData = movesRes.data || [];
      const utilitiesData = utilitiesRes.data || [];
      setMoves(movesData);
      setUtilities(utilitiesData);

      if (movesData.length > 0) {
        const firstId = String(movesData[0].id);
        setSelectedMoveId(firstId);
        await loadMoveUtilities(firstId);
      } else {
        setMoveUtilities([]);
      }
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load utilities.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const loadMoveUtilities = async (moveId) => {
    if (!moveId) {
      setMoveUtilities([]);
      return;
    }
    setTableLoading(true);
    setError("");
    try {
      const res = await apiClient.get(`/moves/${moveId}/utilities`);
      setMoveUtilities(res.data || []);
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load utilities for this move.";
      setError(msg);
    } finally {
      setTableLoading(false);
    }
  };

  useEffect(() => {
    loadInitial();
  }, []);

  const handleMoveFilterChange = async (e) => {
    const value = e.target.value;
    setSelectedMoveId(value);
    await loadMoveUtilities(value);
  };

  const openCreateDialog = () => {
    setEditingMu(null);
    setForm({
      move_id: selectedMoveId || "",
      utility_id: "",
      account_number: "",
      stop_date: "",
      start_date: "",
      status: "planned"
    });
    setDialogError("");
    setDialogOpen(true);
  };

  const openEditDialog = (mu) => {
    setEditingMu(mu);
    setForm({
      move_id: String(mu.move_id),
      utility_id: String(mu.utility_id),
      account_number: mu.account_number || "",
      stop_date: mu.stop_date ? mu.stop_date.substring(0, 10) : "",
      start_date: mu.start_date ? mu.start_date.substring(0, 10) : "",
      status: mu.status || "planned"
    });
    setDialogError("");
    setDialogOpen(true);
  };

  const closeDialog = () => {
    if (saving) return;
    setDialogOpen(false);
  };

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setDialogError("");

    const { move_id, utility_id, account_number, stop_date, start_date, status } =
      form;

    if (!move_id || !utility_id) {
      setDialogError("Move and Utility are required.");
      return;
    }

    const basePayload = {
      account_number: account_number || null,
      stop_date: stop_date || null,
      start_date: start_date || null,
      status
    };

    setSaving(true);
    try {
      if (editingMu) {
        await apiClient.patch(
          `/moves/${move_id}/utilities/${utility_id}`,
          basePayload
        );
      } else {
        const payload = {
          ...basePayload,
          utility_id: Number(utility_id)
        };
        await apiClient.post(`/moves/${move_id}/utilities`, payload);
      }

      setSelectedMoveId(String(move_id));
      await loadMoveUtilities(move_id);
      setDialogOpen(false);
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save utility.";
      setDialogError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (mu) => {
    const ok = window.confirm(
      `Delete utility "${mu.provider_name}" for this move? This cannot be undone.`
    );
    if (!ok) return;

    try {
      await apiClient.delete(
        `/moves/${mu.move_id}/utilities/${mu.utility_id}`
      );
      await loadMoveUtilities(selectedMoveId);
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete utility.";
      alert(msg);
    }
  };

  const getMoveTitle = (moveId) => {
    const move = moves.find((m) => String(m.id) === String(moveId));
    return move ? move.title : `Move #${moveId}`;
  };

  const getUtilityInfo = (utilityId) => {
    const u = utilities.find((ut) => String(ut.id) === String(utilityId));
    if (!u) return { name: `Utility #${utilityId}`, type: "" };
    return { name: u.provider_name, type: u.type };
  };

  return (
    <AppLayout title="Utilities">
      <Box
        sx={{
          mb: 3,
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center"
        }}
      >
        <Box>
          <Typography variant="h4" gutterBottom>
            Utilities
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Track electricity, internet and other services for your moves.
          </Typography>
        </Box>

        <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
          <TextField
            select
            size="small"
            label="Move"
            value={selectedMoveId}
            onChange={handleMoveFilterChange}
            sx={{ minWidth: 220 }}
          >
            {moves.length === 0 ? (
              <MenuItem value="">
                <em>No moves yet</em>
              </MenuItem>
            ) : (
              moves.map((m) => (
                <MenuItem key={m.id} value={String(m.id)}>
                  {m.title}
                </MenuItem>
              ))
            )}
          </TextField>

          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={openCreateDialog}
            disabled={moves.length === 0 || utilities.length === 0}
          >
            Add utility
          </Button>
        </Box>
      </Box>

      {loading ? (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 4 }}>
          <CircularProgress />
        </Box>
      ) : error ? (
        <Alert severity="error">{error}</Alert>
      ) : moves.length === 0 ? (
        <Alert severity="info">
          You need at least one move to attach utilities. Create a move first.
        </Alert>
      ) : (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 1 }}>
          <Paper
            sx={{
              width: "100%",
              maxWidth: 1000,
              bgcolor: "#020617",
              borderRadius: 2,
              border: "1px solid #111827",
              overflow: "hidden"
            }}
          >
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell sx={{ color: "#E5E7EB", width: "16.6%" }}>
                    Move
                  </TableCell>
                  <TableCell sx={{ color: "#E5E7EB", width: "16.6%" }}>
                    Provider
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "16.6%" }}
                    align="center"
                  >
                    Type
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "16.6%" }}
                    align="center"
                  >
                    Dates
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "16.6%" }}
                    align="center"
                  >
                    Status
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "16.6%" }}
                    align="center"
                  >
                    Actions
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {tableLoading ? (
                  <TableRow>
                    <TableCell colSpan={6} align="center">
                      <CircularProgress size={22} />
                    </TableCell>
                  </TableRow>
                ) : moveUtilities.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={6} sx={{ color: "text.secondary" }}>
                      No utilities for this move yet. Click "Add utility" to
                      create one.
                    </TableCell>
                  </TableRow>
                ) : (
                  moveUtilities.map((mu) => {
                    const info = getUtilityInfo(mu.utility_id);
                    return (
                      <TableRow
                        key={`${mu.move_id}-${mu.utility_id}`}
                        hover
                      >
                        <TableCell sx={{ color: "#F9FAFB" }}>
                          {getMoveTitle(mu.move_id)}
                        </TableCell>
                        <TableCell sx={{ color: "#F9FAFB" }}>
                          {mu.provider_name || info.name}
                        </TableCell>
                        <TableCell align="center">
                          <Chip
                            label={
                              TYPE_LABELS[mu.type || info.type] ||
                              mu.type ||
                              info.type ||
                              "Other"
                            }
                            size="small"
                            sx={{ fontSize: 11 }}
                          />
                        </TableCell>
                        <TableCell
                          align="center"
                          sx={{ color: "text.secondary", fontSize: 13 }}
                        >
                          {mu.stop_date
                            ? `Stop: ${mu.stop_date.substring(0, 10)}`
                            : "Stop: —"}
                          <br />
                          {mu.start_date
                            ? `Start: ${mu.start_date.substring(0, 10)}`
                            : "Start: —"}
                        </TableCell>
                        <TableCell align="center">
                          <Chip
                            label={formatStatus(mu.status)}
                            size="small"
                            sx={{ fontSize: 11 }}
                          />
                        </TableCell>
                        <TableCell align="center">
                          <Box
                            sx={{
                              display: "inline-flex",
                              alignItems: "center",
                              gap: 1
                            }}
                          >
                            <IconButton
                              size="small"
                              onClick={() => openEditDialog(mu)}
                            >
                              <EditIcon fontSize="small" />
                            </IconButton>
                            <IconButton
                              size="small"
                              color="error"
                              onClick={() => handleDelete(mu)}
                            >
                              <DeleteIcon fontSize="small" />
                            </IconButton>
                          </Box>
                        </TableCell>
                      </TableRow>
                    );
                  })
                )}
              </TableBody>
            </Table>
          </Paper>
        </Box>
      )}

      <Dialog
        open={dialogOpen}
        onClose={saving ? undefined : closeDialog}
        fullWidth
        maxWidth="sm"
      >
        <DialogTitle>
          {editingMu ? "Edit utility" : "Add utility"}
        </DialogTitle>
        <DialogContent dividers>
          {dialogError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {dialogError}
            </Alert>
          )}

          <Box
            component="form"
            onSubmit={handleSave}
            sx={{ mt: 1, display: "flex", flexDirection: "column", gap: 2 }}
          >
            <TextField
              select
              label="Move"
              name="move_id"
              value={form.move_id}
              onChange={handleFormChange}
            >
              {moves.map((m) => (
                <MenuItem key={m.id} value={String(m.id)}>
                  {m.title}
                </MenuItem>
              ))}
            </TextField>

            <TextField
              select
              label="Utility provider"
              name="utility_id"
              value={form.utility_id}
              onChange={handleFormChange}
            >
              {utilities.map((u) => (
                <MenuItem key={u.id} value={String(u.id)}>
                  {u.provider_name} (
                  {TYPE_LABELS[u.type] || u.type || "Other"})
                </MenuItem>
              ))}
            </TextField>

            <TextField
              label="Account number"
              name="account_number"
              fullWidth
              value={form.account_number}
              onChange={handleFormChange}
            />

            <Box
              sx={{
                display: "flex",
                gap: 2,
                flexDirection: { xs: "column", sm: "row" }
              }}
            >
              <TextField
                label="Stop date"
                type="date"
                name="stop_date"
                InputLabelProps={{ shrink: true }}
                value={form.stop_date}
                onChange={handleFormChange}
                sx={{ flex: 1 }}
              />
              <TextField
                label="Start date"
                type="date"
                name="start_date"
                InputLabelProps={{ shrink: true }}
                value={form.start_date}
                onChange={handleFormChange}
                sx={{ flex: 1 }}
              />
            </Box>

            <TextField
              select
              label="Status"
              name="status"
              value={form.status}
              onChange={handleFormChange}
            >
              {STATUS_OPTIONS.map((s) => (
                <MenuItem key={s.value} value={s.value}>
                  {s.label}
                </MenuItem>
              ))}
            </TextField>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDialog} disabled={saving}>
            Cancel
          </Button>
          <Button onClick={handleSave} variant="contained" disabled={saving}>
            {saving
              ? "Saving..."
              : editingMu
              ? "Save changes"
              : "Add utility"}
          </Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default UtilitiesPage;
