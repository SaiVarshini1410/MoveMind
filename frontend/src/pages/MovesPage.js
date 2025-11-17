import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  Table,
  TableHead,
  TableBody,
  TableRow,
  TableCell,
  CircularProgress,
  Alert,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem
} from "@mui/material";
import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";


const STATUS_OPTIONS = [
  { value: "planned",     label: "Planned" },
  { value: "packing",     label: "Packing" },
  { value: "in_transit",  label: "In Transit" },
  { value: "unpacking",   label: "Unpacking" },
  { value: "done",        label: "Done" }
];

const formatStatus = (value) => {
  const found = STATUS_OPTIONS.find((s) => s.value === value);
  return found ? found.label : value;
};

function MovesPage() {
  const [moves, setMoves] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");


  const [addresses, setAddresses] = useState([]);
  const [addressesLoading, setAddressesLoading] = useState(false);
  const [addressesError, setAddressesError] = useState("");


  const [openDialog, setOpenDialog] = useState(false);
  const [saving, setSaving] = useState(false);
  const [formError, setFormError] = useState("");


  const [newMove, setNewMove] = useState({
    title: "",
    move_date: "",
    status: "planned",
    from_address_id: "",
    to_address_id: ""
  });

  const fetchMoves = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await apiClient.get("/moves");
      setMoves(res.data || []);
    } catch (err) {
      console.error("Error fetching moves:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load moves.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const fetchAddresses = async () => {
    setAddressesLoading(true);
    setAddressesError("");
    try {
      const res = await apiClient.get("/addresses");
      setAddresses(res.data || []);
    } catch (err) {
      console.error("Error fetching addresses:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load addresses.";
      setAddressesError(msg);
    } finally {
      setAddressesLoading(false);
    }
  };

  useEffect(() => {
    fetchMoves();
    fetchAddresses();
  }, []);

  const handleOpenDialog = () => {
    setFormError("");
    setNewMove({
      title: "",
      move_date: "",
      status: "planned",
      from_address_id: "",
      to_address_id: ""
    });
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    if (saving) return;
    setOpenDialog(false);
  };

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setNewMove((prev) => ({
      ...prev,
      [name]: value
    }));
  };

  const handleCreateMove = async (e) => {
    e.preventDefault();
    setFormError("");

    if (!newMove.title || !newMove.from_address_id || !newMove.to_address_id) {
      setFormError("Title, From address, and To address are required.");
      return;
    }

    setSaving(true);
    try {
      const payload = {
        title: newMove.title,
        move_date: newMove.move_date || null,
        status: newMove.status,
        from_address_id: parseInt(newMove.from_address_id, 10),
        to_address_id: parseInt(newMove.to_address_id, 10)
      };

      await apiClient.post("/moves", payload);
      setOpenDialog(false);
      await fetchMoves();
    } catch (err) {
      console.error("Error creating move:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to create move.";
      setFormError(msg);
    } finally {
      setSaving(false);
    }
  };

  const noAddresses = !addressesLoading && addresses.length === 0;

  return (
    <AppLayout title="Moves">
      <Box
        sx={{
          mb: 3,
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between"
        }}
      >
        <Box>
          <Typography variant="h4" gutterBottom>
            Moves
          </Typography>
          <Typography variant="body2" color="text.secondary">
            View and create moves. Each move links a from / to address.
          </Typography>
        </Box>

        <Button variant="contained" onClick={handleOpenDialog}>
          New Move
        </Button>
      </Box>


      {addressesError && (
        <Alert severity="warning" sx={{ mb: 2 }}>
          {addressesError}
        </Alert>
      )}


      {loading && (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 4 }}>
          <CircularProgress />
        </Box>
      )}

      {error && !loading && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {!loading && !error && (
        <Paper
          sx={{
            bgcolor: "#020617",
            borderRadius: 2,
            border: "1px solid #111827",
            overflow: "hidden"
          }}
        >
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell sx={{ color: "#E5E7EB" }}>Title</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Move date</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Status</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Created at</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {moves.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} sx={{ color: "text.secondary" }}>
                    No moves yet. Click &quot;New Move&quot; to create one.
                  </TableCell>
                </TableRow>
              ) : (
                moves.map((m) => (
                  <TableRow key={m.id} hover>
                    <TableCell sx={{ color: "#F9FAFB" }}>{m.title}</TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {m.move_date
                        ? new Date(m.move_date).toLocaleDateString()
                        : "-"}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {formatStatus(m.status)}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {m.created_at
                        ? new Date(m.created_at).toLocaleString()
                        : "-"}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </Paper>
      )}

      <Dialog open={openDialog} onClose={handleCloseDialog} fullWidth maxWidth="sm">
        <DialogTitle>New Move</DialogTitle>
        <DialogContent>
          {formError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {formError}
            </Alert>
          )}

          {addressesLoading && (
            <Alert severity="info" sx={{ mb: 2 }}>
              Loading addresses...
            </Alert>
          )}

          {noAddresses && (
            <Alert severity="info" sx={{ mb: 2 }}>
              You don&apos;t have any addresses yet. You&apos;ll need at least
              two (from &amp; to) before creating a move.
            </Alert>
          )}

          <Box component="form" onSubmit={handleCreateMove} sx={{ mt: 1 }}>
            <TextField
              fullWidth
              label="Title"
              name="title"
              margin="normal"
              value={newMove.title}
              onChange={handleFormChange}
              required
            />

            <TextField
              fullWidth
              label="Move date"
              name="move_date"
              type="date"
              margin="normal"
              value={newMove.move_date}
              onChange={handleFormChange}
              InputLabelProps={{
                shrink: true
              }}
            />

            <TextField
              select
              fullWidth
              label="Status"
              name="status"
              margin="normal"
              value={newMove.status}
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
              fullWidth
              label="From address"
              name="from_address_id"
              margin="normal"
              value={newMove.from_address_id}
              onChange={handleFormChange}
              disabled={addressesLoading || noAddresses}
              required
              helperText={
                noAddresses
                  ? "Add addresses first."
                  : "Select the address you are moving from."
              }
            >
              {addresses.map((addr) => (
                <MenuItem key={addr.id} value={addr.id}>
                  {addr.label} – {addr.city}, {addr.state}
                </MenuItem>
              ))}
            </TextField>

            <TextField
              select
              fullWidth
              label="To address"
              name="to_address_id"
              margin="normal"
              value={newMove.to_address_id}
              onChange={handleFormChange}
              disabled={addressesLoading || noAddresses}
              required
              helperText={
                noAddresses
                  ? "Add addresses first."
                  : "Select the address you are moving to."
              }
            >
              {addresses.map((addr) => (
                <MenuItem key={addr.id} value={addr.id}>
                  {addr.label} – {addr.city}, {addr.state}
                </MenuItem>
              ))}
            </TextField>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog} disabled={saving}>
            Cancel
          </Button>
          <Button
            onClick={handleCreateMove}
            variant="contained"
            disabled={saving || addressesLoading || noAddresses}
          >
            {saving ? "Saving..." : "Create"}
          </Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default MovesPage;
