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
  IconButton
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import { useParams, useNavigate } from "react-router-dom";

import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

function RoomsPage() {
  const { moveId } = useParams();
  const navigate = useNavigate();

  const [move, setMove] = useState(null);
  const [rooms, setRooms] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [dialogOpen, setDialogOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [dialogError, setDialogError] = useState("");
  const [editingRoom, setEditingRoom] = useState(null);

  const [form, setForm] = useState({
    name: "",
    floor: ""
  });

  const loadData = async () => {
    setLoading(true);
    setError("");

    try {
      const [roomsRes, moveRes] = await Promise.all([
        apiClient.get(`/moves/${moveId}/rooms`),
        apiClient.get(`/moves/${moveId}`)
      ]);

      setRooms(roomsRes.data || []);
      setMove(moveRes.data || null);
    } catch (err) {
      console.error("Error loading rooms/move:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load rooms.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (moveId) {
      loadData();
    }
  }, [moveId]);

  const handleBackToMoves = () => {
    navigate("/moves");
  };

  const openCreateDialog = () => {
    setEditingRoom(null);
    setForm({
      name: "",
      floor: ""
    });
    setDialogError("");
    setDialogOpen(true);
  };

  const openEditDialog = (room) => {
    setEditingRoom(room);
    setForm({
      name: room.name || "",
      floor: room.floor != null ? String(room.floor) : ""
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

    if (!form.name) {
      setDialogError("Room name is required.");
      return;
    }

    const payload = {
      name: form.name,
      floor: form.floor !== "" ? form.floor : null
    };

    setSaving(true);
    try {
      if (editingRoom) {
        await apiClient.patch(
          `/moves/${moveId}/rooms/${encodeURIComponent(editingRoom.name)}`,
          payload
        );
      } else {
        await apiClient.post(`/moves/${moveId}/rooms`, payload);
      }
      await loadData();
      setDialogOpen(false);
    } catch (err) {
      console.error("Error saving room:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save room.";
      setDialogError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (room) => {
    const ok = window.confirm(
      `Delete room "${room.name}"? This will also delete its boxes and items.`
    );
    if (!ok) return;

    try {
      await apiClient.delete(
        `/moves/${moveId}/rooms/${encodeURIComponent(room.name)}`
      );
      await loadData();
    } catch (err) {
      console.error("Error deleting room:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete room.";
      alert(msg);
    }
  };

  const handleGoToBoxes = (room) => {
    navigate(`/moves/${moveId}/rooms/${encodeURIComponent(room.name)}/boxes`);
  };

  return (
    <AppLayout title="Rooms">
      <Box
        sx={{
          mb: 3,
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center"
        }}
      >
        <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
          <Button
            variant="outlined"
            size="small"
            startIcon={<ArrowBackIcon />}
            onClick={handleBackToMoves}
          >
            Back to moves
          </Button>
          <Box>
            <Typography variant="h4" gutterBottom>
              Rooms
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {move ? `Organize rooms for: ${move.title}` : "Organize rooms"}
            </Typography>
          </Box>
        </Box>

        <Box sx={{ display: "flex", alignItems: "center" }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={openCreateDialog}
          >
            New room
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
                    Room name
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "20%" }}
                    align="center"
                  >
                    Floor
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "40%" }}
                    align="center"
                  >
                    Actions
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {rooms.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={3} sx={{ color: "text.secondary" }}>
                      No rooms yet. Click &quot;New room&quot; to add one.
                    </TableCell>
                  </TableRow>
                ) : (
                  rooms.map((room) => (
                    <TableRow
                      key={`${room.move_id}-${room.name}`}
                      hover
                    >
                      <TableCell sx={{ color: "#F9FAFB" }}>
                        {room.name}
                      </TableCell>
                      <TableCell
                        sx={{ color: "text.secondary" }}
                        align="center"
                      >
                        {room.floor || "—"}
                      </TableCell>
                      <TableCell align="center">
                        <Box
                          sx={{
                            display: "inline-flex",
                            alignItems: "center",
                            gap: 1
                          }}
                        >
                          <Button
                            size="small"
                            variant="text"
                            onClick={() => handleGoToBoxes(room)}
                          >
                            Boxes
                          </Button>
                          <IconButton
                            size="small"
                            onClick={() => openEditDialog(room)}
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDelete(room)}
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
          {editingRoom ? "Edit room" : "Create a new room"}
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
              label="Room name *"
              name="name"
              fullWidth
              value={form.name}
              onChange={handleFormChange}
            />

            <TextField
              label="Floor (optional)"
              name="floor"
              fullWidth
              value={form.floor}
              onChange={handleFormChange}
              helperText='For example: "1", "2", "Basement", etc.'
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDialog} disabled={saving}>
            Cancel
          </Button>
          <Button onClick={handleSave} variant="contained" disabled={saving}>
            {saving
              ? "Saving..."
              : editingRoom
              ? "Save changes"
              : "Create room"}
          </Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default RoomsPage;
