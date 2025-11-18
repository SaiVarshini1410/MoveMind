import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  Button,
  Alert,
  CircularProgress,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  IconButton,
  Checkbox,
  FormControlLabel,
  Chip,
  List,
  ListItem,
  ListItemText,
  Divider
} from "@mui/material";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import AddIcon from "@mui/icons-material/Add";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import QrCode2Icon from "@mui/icons-material/QrCode2";
import WarningAmberOutlinedIcon from "@mui/icons-material/WarningAmberOutlined";

import { QRCodeCanvas } from "qrcode.react";
import { useParams, useNavigate } from "react-router-dom";

import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

const STATUS_OPTIONS = [
  { value: "empty", label: "Empty" },
  { value: "packed", label: "Packed" },
  { value: "loaded", label: "Loaded" },
  { value: "delivered", label: "Delivered" },
  { value: "unpacked", label: "Unpacked" }
];

const formatStatus = (value) => {
  const found = STATUS_OPTIONS.find((s) => s.value === value);
  return found ? found.label : value;
};

function BoxesPage() {
  const { moveId, roomId } = useParams();
  const navigate = useNavigate();

  const [move, setMove] = useState(null);
  const [room, setRoom] = useState(null);
  const [boxes, setBoxes] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [dialogOpen, setDialogOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [dialogError, setDialogError] = useState("");
  const [editingBox, setEditingBox] = useState(null);

  const [qrDialogOpen, setQrDialogOpen] = useState(false);
  const [qrBox, setQrBox] = useState(null);
  const [qrLoading, setQrLoading] = useState(false);
  const [qrText, setQrText] = useState("");
  const [qrError, setQrError] = useState("");

  const [itemsDialogOpen, setItemsDialogOpen] = useState(false);
  const [itemsBox, setItemsBox] = useState(null);
  const [itemsLoading, setItemsLoading] = useState(false);
  const [itemsError, setItemsError] = useState("");
  const [items, setItems] = useState([]);

  const [itemForm, setItemForm] = useState({
    name: "",
    quantity: 1,
    value: ""
  });
  const [itemSaving, setItemSaving] = useState(false);
  const [itemFormError, setItemFormError] = useState("");

  const [form, setForm] = useState({
    label_code: "",
    fragile: false,
    weight: "",
    status: "empty"
  });

  const loadData = async () => {
    setLoading(true);
    setError("");

    try {
      const [boxesRes, moveRes, roomsRes] = await Promise.all([
        apiClient.get(`/rooms/${roomId}/boxes`),
        apiClient.get(`/moves/${moveId}`),
        apiClient.get(`/moves/${moveId}/rooms`)
      ]);

      setBoxes(boxesRes.data || []);
      setMove(moveRes.data || null);

      const rooms = roomsRes.data || [];
      const foundRoom = rooms.find((r) => String(r.id) === String(roomId));
      setRoom(foundRoom || null);
    } catch (err) {
      console.error("Error loading boxes/move/room:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load boxes.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (moveId && roomId) {
      loadData();
    }
  }, [moveId, roomId]);

  const handleBackToRooms = () => {
    navigate(`/moves/${moveId}/rooms`);
  };

  const openCreateDialog = () => {
    setEditingBox(null);
    setForm({
      label_code: "",
      fragile: false,
      weight: "",
      status: "empty"
    });
    setDialogError("");
    setDialogOpen(true);
  };

  const openEditDialog = (box) => {
    setEditingBox(box);
    setForm({
      label_code: box.label_code || "",
      fragile: !!box.fragile,
      weight: box.weight != null ? String(box.weight) : "",
      status: box.status || "empty"
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

  const handleFragileChange = (e) => {
    setForm((prev) => ({ ...prev, fragile: e.target.checked }));
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setDialogError("");

    if (!form.label_code) {
      setDialogError("Label code is required.");
      return;
    }

    const payload = {
      label_code: form.label_code,
      fragile: form.fragile ? 1 : 0,
      weight: form.weight !== "" ? Number(form.weight) : null,
      status: form.status
    };

    setSaving(true);
    try {
      if (editingBox) {
        await apiClient.patch(`/boxes/${editingBox.id}`, payload);
      } else {
        await apiClient.post(`/rooms/${roomId}/boxes`, payload);
      }
      await loadData();
      setDialogOpen(false);
    } catch (err) {
      console.error("Error saving box:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save box.";
      setDialogError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (box) => {
    const ok = window.confirm(
      `Delete box "${box.label_code}"? This will also delete its items.`
    );
    if (!ok) return;

    try {
      await apiClient.delete(`/boxes/${box.id}`);
      await loadData();
    } catch (err) {
      console.error("Error deleting box:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete box.";
      alert(msg);
    }
  };


  const loadItems = async (boxId) => {
    setItemsLoading(true);
    setItemsError("");
    try {
      const res = await apiClient.get(`/boxes/${boxId}/items`);
      setItems(res.data || []);
    } catch (err) {
      console.error("Error loading items:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load items.";
      setItemsError(msg);
    } finally {
      setItemsLoading(false);
    }
  };

  const handleOpenItemsDialog = async (box) => {
    setItemsBox(box);
    setItemsDialogOpen(true);
    setItemFormError("");
    setItemForm({ name: "", quantity: 1, value: "" });
    await loadItems(box.id);
  };

  const handleCloseItemsDialog = () => {
    if (itemSaving) return;
    setItemsDialogOpen(false);
    setItemsBox(null);
    setItems([]);
    setItemsError("");
    setItemFormError("");
  };

  const handleItemFormChange = (e) => {
    const { name, value } = e.target;
    setItemForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleAddItem = async (e) => {
    e.preventDefault();
    setItemFormError("");

    if (!itemForm.name.trim()) {
      setItemFormError("Item name is required.");
      return;
    }

    const payload = {
      name: itemForm.name.trim(),
      quantity:
        itemForm.quantity !== "" ? Number(itemForm.quantity) || 1 : 1,
      value: itemForm.value !== "" ? Number(itemForm.value) : null
    };

    setItemSaving(true);
    try {
      await apiClient.post(`/boxes/${itemsBox.id}/items`, payload);
      await loadItems(itemsBox.id);
      setItemForm({ name: "", quantity: 1, value: "" });
    } catch (err) {
      console.error("Error adding item:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to add item.";
      setItemFormError(msg);
    } finally {
      setItemSaving(false);
    }
  };

  const handleDeleteItem = async (item) => {
    const ok = window.confirm(`Delete item "${item.name}" from this box?`);
    if (!ok) return;

    try {
      await apiClient.delete(`/items/${item.id}`);
      await loadItems(itemsBox.id);
    } catch (err) {
      console.error("Error deleting item:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete item.";
      alert(msg);
    }
  };


  const handleOpenQrDialog = async (box) => {
    setQrBox(box);
    setQrDialogOpen(true);
    setQrLoading(true);
    setQrText("");
    setQrError("");

    try {
      const itemsRes = await apiClient.get(`/boxes/${box.id}/items`);
      const items = itemsRes.data || [];

      const headerLines = [
        `MoveMind – Box: ${box.label_code}`,
        room && move ? `Room: ${room.name} | Move: ${move.title}` : "",
        `Status: ${formatStatus(box.status)}`,
        `Weight: ${box.weight != null ? box.weight : "—"}`,
        "",
        "Items:"
      ].filter(Boolean);

      const itemLines =
        items.length > 0
          ? items.map((it) => {
              let line = `• ${it.name}`;
              if (it.quantity != null) line += ` x${it.quantity}`;
              if (it.value != null) line += ` (value: ${it.value})`;
              return line;
            })
          : ["• (no items recorded)"];

      const fullText = [...headerLines, ...itemLines].join("\n");
      setQrText(fullText);
    } catch (err) {
      console.error("Error loading items for QR:", err);
      setQrError("Failed to load items for QR code.");
    } finally {
      setQrLoading(false);
    }
  };

  const handleCloseQrDialog = () => {
    setQrDialogOpen(false);
    setQrBox(null);
    setQrText("");
    setQrError("");
  };

  return (
    <AppLayout title="Boxes">

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
            onClick={handleBackToRooms}
          >
            Back to rooms
          </Button>
          <Box>
            <Typography variant="h4" gutterBottom>
              Boxes
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {room && move
                ? `Room: ${room.name} • Move: ${move.title}`
                : `Boxes for room #${roomId}`}
            </Typography>
          </Box>
        </Box>

        <Box sx={{ display: "flex", alignItems: "center" }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={openCreateDialog}
          >
            New box
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
        <Box sx={{ mt: 1 }}>
          {boxes.length === 0 ? (
            <Alert severity="info">
              No boxes yet in this room. Click &quot;New box&quot; to create one.
            </Alert>
          ) : (
            <Box
              sx={{
                maxWidth: 1100,
                mx: "auto",
                display: "grid",
                gridTemplateColumns: {
                  xs: "1fr",
                  sm: "repeat(2, minmax(0, 1fr))",
                  md: "repeat(3, minmax(0, 1fr))"
                },
                gap: 3,
                alignItems: "stretch"
              }}
            >
              {boxes.map((box) => (
                <Paper
                  key={box.id}
                  sx={{
                    p: 2,
                    bgcolor: "#020617",
                    borderRadius: 3,
                    border: "1px solid #111827",
                    display: "flex",
                    flexDirection: "column",
                    gap: 1.5,
                    minHeight: 170
                  }}
                >
            
                  <Box
                    sx={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center"
                    }}
                  >
                    <Typography
                      variant="subtitle1"
                      sx={{ fontWeight: 600, color: "#F9FAFB" }}
                      noWrap
                    >
                      {box.label_code}
                    </Typography>
                    <Box
                      sx={{
                        display: "flex",
                        alignItems: "center",
                        gap: 1
                      }}
                    >
                      <Chip
                        label={formatStatus(box.status)}
                        size="small"
                        sx={{ fontSize: 11 }}
                      />
                      {box.fragile ? (
                        <WarningAmberOutlinedIcon
                          fontSize="small"
                          sx={{ color: "#f97316" }}
                          titleAccess="Fragile"
                        />
                      ) : null}
                    </Box>
                  </Box>

        
                  <Typography
                    variant="body2"
                    sx={{ color: "text.secondary" }}
                  >
                    Weight:{" "}
                    {box.weight != null && box.weight !== ""
                      ? box.weight
                      : "—"}
                  </Typography>

             
                  <Box
                    sx={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                      mt: 1
                    }}
                  >
                    <Button
                      size="small"
                      variant="outlined"
                      onClick={() => handleOpenItemsDialog(box)}
                    >
                      ITEMS
                    </Button>
                    <Button
                      size="small"
                      variant="outlined"
                      startIcon={<QrCode2Icon />}
                      onClick={() => handleOpenQrDialog(box)}
                    >
                      QR CODE
                    </Button>
                  </Box>


                  <Box
                    sx={{
                      display: "flex",
                      justifyContent: "flex-start",
                      alignItems: "center",
                      mt: 0.5
                    }}
                  >
                    <IconButton
                      size="small"
                      onClick={() => openEditDialog(box)}
                    >
                      <EditIcon fontSize="small" />
                    </IconButton>
                    <IconButton
                      size="small"
                      color="error"
                      onClick={() => handleDelete(box)}
                    >
                      <DeleteIcon fontSize="small" />
                    </IconButton>
                  </Box>
                </Paper>
              ))}
            </Box>
          )}
        </Box>
      )}


      <Dialog
        open={dialogOpen}
        onClose={saving ? undefined : closeDialog}
        fullWidth
        maxWidth="sm"
      >
        <DialogTitle>
          {editingBox ? "Edit box" : "Create a new box"}
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
              label="Label code *"
              name="label_code"
              fullWidth
              value={form.label_code}
              onChange={handleFormChange}
              helperText="This will be printed on the box and used for the QR."
            />

            <FormControlLabel
              control={
                <Checkbox
                  checked={form.fragile}
                  onChange={handleFragileChange}
                />
              }
              label="Fragile"
            />

            <TextField
              label="Weight (optional)"
              name="weight"
              type="number"
              fullWidth
              value={form.weight}
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
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDialog} disabled={saving}>
            Cancel
          </Button>
          <Button onClick={handleSave} variant="contained" disabled={saving}>
            {saving
              ? "Saving..."
              : editingBox
              ? "Save changes"
              : "Create box"}
          </Button>
        </DialogActions>
      </Dialog>


      <Dialog
        open={qrDialogOpen}
        onClose={handleCloseQrDialog}
        fullWidth
        maxWidth="xs"
      >
        <DialogTitle>
          {qrBox ? `QR for ${qrBox.label_code}` : "Box QR code"}
        </DialogTitle>
        <DialogContent
          dividers
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            minHeight: 260
          }}
        >
          {qrLoading ? (
            <Box sx={{ mt: 4, mb: 2 }}>
              <CircularProgress />
            </Box>
          ) : qrError ? (
            <Alert severity="error">{qrError}</Alert>
          ) : qrText ? (
            <>
              <QRCodeCanvas value={qrText} size={200} includeMargin />
              <Typography
                variant="body2"
                sx={{ mt: 2, textAlign: "center", color: "text.secondary" }}
              >
                This QR contains a text snapshot of this box and its items.
                Scan it with any QR scanner to see the list. You can screenshot
                and stick it on the physical box.
              </Typography>
            </>
          ) : null}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseQrDialog}>Close</Button>
        </DialogActions>
      </Dialog>


      <Dialog
        open={itemsDialogOpen}
        onClose={handleCloseItemsDialog}
        fullWidth
        maxWidth="sm"
      >
        <DialogTitle>
          {itemsBox ? `Items in box: ${itemsBox.label_code}` : "Box items"}
        </DialogTitle>
        <DialogContent dividers>
          {itemsError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {itemsError}
            </Alert>
          )}

          {itemsLoading ? (
            <Box sx={{ display: "flex", justifyContent: "center", my: 3 }}>
              <CircularProgress size={28} />
            </Box>
          ) : (
            <>
              {items.length === 0 ? (
                <Typography
                  variant="body2"
                  sx={{ mb: 2, color: "text.secondary" }}
                >
                  No items in this box yet. Add your first item below.
                </Typography>
              ) : (
                <Paper
                  variant="outlined"
                  sx={{
                    mb: 2,
                    bgcolor: "#020617",
                    borderRadius: 2,
                    borderColor: "#111827"
                  }}
                >
                  <List dense disablePadding>
                    {items.map((item, index) => (
                      <React.Fragment key={item.id}>
                        {index !== 0 && <Divider component="li" />}
                        <ListItem
                          secondaryAction={
                            <IconButton
                              edge="end"
                              size="small"
                              color="error"
                              onClick={() => handleDeleteItem(item)}
                            >
                              <DeleteIcon fontSize="small" />
                            </IconButton>
                          }
                        >
                          <ListItemText
                            primary={item.name}
                            primaryTypographyProps={{
                              sx: { fontWeight: 500, color: "#F9FAFB" }
                            }}
                            secondary={
                              <>
                                Qty: {item.quantity ?? 1}
                                {item.value != null
                                  ? ` • Value: ${item.value}`
                                  : ""}
                              </>
                            }
                          />
                        </ListItem>
                      </React.Fragment>
                    ))}
                  </List>
                </Paper>
              )}

              <Box
                component="form"
                onSubmit={handleAddItem}
                sx={{
                  mt: 1,
                  display: "flex",
                  flexDirection: "column",
                  gap: 1.5
                }}
              >
                {itemFormError && (
                  <Alert severity="error">{itemFormError}</Alert>
                )}

                <TextField
                  label="Item name *"
                  name="name"
                  value={itemForm.name}
                  onChange={handleItemFormChange}
                  fullWidth
                />

                <Box
                  sx={{
                    display: "flex",
                    gap: 1,
                    flexWrap: "wrap"
                  }}
                >
                  <TextField
                    label="Quantity"
                    name="quantity"
                    type="number"
                    value={itemForm.quantity}
                    onChange={handleItemFormChange}
                    sx={{ width: 120 }}
                  />
                  <TextField
                    label="Value (optional)"
                    name="value"
                    type="number"
                    value={itemForm.value}
                    onChange={handleItemFormChange}
                    sx={{ width: 160 }}
                  />
                </Box>

                <Box sx={{ display: "flex", justifyContent: "flex-end" }}>
                  <Button
                    type="submit"
                    variant="contained"
                    size="small"
                    disabled={itemSaving || !itemsBox}
                  >
                    {itemSaving ? "Adding..." : "Add item"}
                  </Button>
                </Box>
              </Box>
            </>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseItemsDialog}>Close</Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default BoxesPage;
