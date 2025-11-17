// src/pages/MovesPage.js
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
  IconButton
} from "@mui/material";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import AddIcon from "@mui/icons-material/Add";
import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

const STATUS_OPTIONS = [
  { value: "planned", label: "Planned" },
  { value: "packing", label: "Packing" },
  { value: "in_transit", label: "In transit" },
  { value: "unpacking", label: "Unpacking" },
  { value: "done", label: "Done" }
];

const formatStatus = (value) => {
  const found = STATUS_OPTIONS.find((s) => s.value === value);
  return found ? found.label : value;
};

function MovesPage() {
  const [moves, setMoves] = useState([]);
  const [addresses, setAddresses] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [dialogOpen, setDialogOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [dialogError, setDialogError] = useState("");

  const [editingMove, setEditingMove] = useState(null);

  const [form, setForm] = useState({
    title: "",
    move_date: "",
    status: "planned",
    from_address_id: "",
    to_address_id: ""
  });

  const loadData = async () => {
    setLoading(true);
    setError("");
    try {
      const [movesRes, addrRes] = await Promise.all([
        apiClient.get("/moves"),
        apiClient.get("/addresses")
      ]);
      setMoves(movesRes.data || []);
      setAddresses(addrRes.data || []);
    } catch (err) {
      console.error("Error loading moves/addresses:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load moves.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const openCreateDialog = () => {
    setEditingMove(null);
    setForm({
      title: "",
      move_date: "",
      status: "planned",
      from_address_id: "",
      to_address_id: ""
    });
    setDialogError("");
    setDialogOpen(true);
  };

  const openEditDialog = (move) => {
    setEditingMove(move);

    let dateValue = "";
    if (move.move_date) {
      dateValue = move.move_date.substring(0, 10); // YYYY-MM-DD
    }

    setForm({
      title: move.title || "",
      move_date: dateValue,
      status: move.status || "planned",
      from_address_id: move.from_address_id || "",
      to_address_id: move.to_address_id || ""
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

    const { title, move_date, status, from_address_id, to_address_id } = form;

    if (!title || !from_address_id || !to_address_id) {
      setDialogError("Title, From address and To address are required.");
      return;
    }

    const payload = {
      title,
      move_date: move_date || null,
      status,
      from_address_id: Number(from_address_id),
      to_address_id: Number(to_address_id)
    };

    setSaving(true);
    try {
      if (editingMove) {
        await apiClient.patch(`/moves/${editingMove.id}`, payload);
      } else {
        await apiClient.post("/moves", payload);
      }
      await loadData();
      setDialogOpen(false);
    } catch (err) {
      console.error("Error saving move:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save move.";
      setDialogError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (move) => {
    const ok = window.confirm(
      `Delete move "${move.title}"? This cannot be undone.`
    );
    if (!ok) return;

    try {
      await apiClient.delete(`/moves/${move.id}`);
      await loadData();
    } catch (err) {
      console.error("Error deleting move:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete move.";
      alert(msg);
    }
  };

  return (
    <AppLayout title="Moves">
      <Box sx={{ mb: 3, display: "flex", justifyContent: "space-between" }}>
        <Box>
          <Typography variant="h4" gutterBottom>
            Moves
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Plan and track each move. Edit details or delete when you are done.
          </Typography>
        </Box>
        <Box sx={{ display: "flex", alignItems: "center" }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={openCreateDialog}
          >
            New move
          </Button>
        </Box>
      </Box>

      {loading ? (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 4 }}>
          <CircularProgress />
        </Box>
      ) : error ? (
        <Alert severity="error">{error}</Alert>
      ) : (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 1 }}>
          <Paper
            sx={{
              width: "100%",
              maxWidth: 900,
              bgcolor: "#020617",
              borderRadius: 2,
              border: "1px solid #111827",
              overflow: "hidden"
            }}
          >
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell sx={{ color: "#E5E7EB", width: "40%" }}>
                    Title
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "20%" }}
                    align="center"
                  >
                    Move date
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "20%" }}
                    align="center"
                  >
                    Status
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "20%" }}
                    align="center"
                  >
                    Actions
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {moves.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={4} sx={{ color: "text.secondary" }}>
                      You don&apos;t have any moves yet. Click &quot;New move&quot; to
                      create one.
                    </TableCell>
                  </TableRow>
                ) : (
                  moves.map((move) => (
                    <TableRow key={move.id} hover>
                      <TableCell sx={{ color: "#F9FAFB" }}>
                        {move.title}
                      </TableCell>
                      <TableCell sx={{ color: "text.secondary" }} align="center">
                        {move.move_date
                          ? move.move_date.substring(0, 10)
                          : "—"}
                      </TableCell>
                      <TableCell sx={{ color: "text.secondary" }} align="center">
                        {formatStatus(move.status)}
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
                            onClick={() => openEditDialog(move)}
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDelete(move)}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Box>
                      </TableCell>
                    </TableRow>
                  ))
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
          {editingMove ? "Edit move" : "Create a new move"}
        </DialogTitle>
        <DialogContent dividers>
          {dialogError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {dialogError}
            </Alert>
          )}

          {addresses.length < 2 && (
            <Alert severity="info" sx={{ mb: 2 }}>
              You need at least two addresses (from / to) to create a move. Add
              them on the Addresses page first.
            </Alert>
          )}

          <Box
            component="form"
            onSubmit={handleSave}
            sx={{ mt: 1, display: "flex", flexDirection: "column", gap: 2 }}
          >
            <TextField
              label="Title"
              name="title"
              fullWidth
              value={form.title}
              onChange={handleFormChange}
            />

            <TextField
              label="Move date"
              type="date"
              name="move_date"
              InputLabelProps={{ shrink: true }}
              value={form.move_date}
              onChange={handleFormChange}
            />

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

            <TextField
              select
              label="From address"
              name="from_address_id"
              value={form.from_address_id}
              onChange={handleFormChange}
            >
              {addresses.map((addr) => (
                <MenuItem key={addr.id} value={addr.id}>
                  {addr.label} — {addr.line1}
                </MenuItem>
              ))}
            </TextField>

            <TextField
              select
              label="To address"
              name="to_address_id"
              value={form.to_address_id}
              onChange={handleFormChange}
            >
              {addresses.map((addr) => (
                <MenuItem key={addr.id} value={addr.id}>
                  {addr.label} — {addr.line1}
                </MenuItem>
              ))}
            </TextField>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDialog} disabled={saving}>
            Cancel
          </Button>
          <Button
            onClick={handleSave}
            variant="contained"
            disabled={saving || addresses.length < 2}
          >
            {saving
              ? "Saving..."
              : editingMove
              ? "Save changes"
              : "Create move"}
          </Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default MovesPage;
