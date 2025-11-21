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
import DeleteIcon from "@mui/icons-material/Delete";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import { useParams, useNavigate } from "react-router-dom";
import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

function formatDateTime(value) {
  if (!value) return "—";
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return value;
  return d.toLocaleString(undefined, {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "numeric",
    minute: "2-digit"
  });
}

function DocumentsPage() {
  const { moveId } = useParams();
  const navigate = useNavigate();

  const [move, setMove] = useState(null);
  const [docs, setDocs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [dialogOpen, setDialogOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [dialogError, setDialogError] = useState("");
  const [form, setForm] = useState({
    doc_type: "",
    file_url: ""
  });

  const loadData = async () => {
    setLoading(true);
    setError("");
    try {
      const [moveRes, docsRes] = await Promise.all([
        apiClient.get(`/moves/${moveId}`),
        apiClient.get(`/moves/${moveId}/documents`)
      ]);
      setMove(moveRes.data || null);
      setDocs(docsRes.data || []);
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load documents.";
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
    setForm({
      doc_type: "",
      file_url: ""
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

    if (!form.doc_type || !form.file_url) {
      setDialogError("Both Type and File URL are required.");
      return;
    }

    setSaving(true);
    try {
      await apiClient.post(`/moves/${moveId}/documents`, {
        doc_type: form.doc_type,
        file_url: form.file_url
      });
      await loadData();
      setDialogOpen(false);
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to save document.";
      setDialogError(msg);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (doc) => {
    const ok = window.confirm(
      `Delete document "${doc.doc_type}"? This cannot be undone.`
    );
    if (!ok) return;

    try {
      await apiClient.delete(`/documents/${doc.id}`);
      await loadData();
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to delete document.";
      alert(msg);
    }
  };

  return (
    <AppLayout title="Documents">
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
              Documents
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {move
                ? `Files for move: ${move.title}`
                : "Upload and track important move documents."}
            </Typography>
          </Box>
        </Box>

        <Box sx={{ display: "flex", alignItems: "center" }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={openCreateDialog}
          >
            Add document
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
                  <TableCell sx={{ color: "#E5E7EB", width: "25%" }}>
                    Type
                  </TableCell>
                  <TableCell sx={{ color: "#E5E7EB", width: "25%" }}>
                    File
                  </TableCell>
                  <TableCell sx={{ color: "#E5E7EB", width: "25%" }}>
                    Uploaded
                  </TableCell>
                  <TableCell
                    sx={{ color: "#E5E7EB", width: "25%" }}
                    align="center"
                  >
                    Actions
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {docs.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={4} sx={{ color: "text.secondary" }}>
                      No documents yet. Click &quot;Add document&quot; to upload
                      one.
                    </TableCell>
                  </TableRow>
                ) : (
                  docs.map((doc) => (
                    <TableRow key={doc.id} hover>
                      <TableCell sx={{ color: "#F9FAFB", width: "25%" }}>
                        {doc.doc_type}
                      </TableCell>
                      <TableCell sx={{ width: "25%" }}>
                        <a
                          href={doc.file_url}
                          target="_blank"
                          rel="noreferrer"
                          style={{
                            color: "#38bdf8",
                            textDecoration: "none",
                            fontSize: 14
                          }}
                        >
                          Open file
                        </a>
                      </TableCell>
                      <TableCell
                        sx={{ color: "text.secondary", width: "25%" }}
                      >
                        {formatDateTime(doc.uploaded_on)}
                      </TableCell>
                      <TableCell
                        sx={{ width: "25%" }}
                        align="center"
                      >
                        <IconButton
                          size="small"
                          color="error"
                          onClick={() => handleDelete(doc)}
                        >
                          <DeleteIcon fontSize="small" />
                        </IconButton>
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
        <DialogTitle>Add document</DialogTitle>
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
              label="Type"
              name="doc_type"
              fullWidth
              value={form.doc_type}
              onChange={handleFormChange}
              placeholder="Lease, Inventory, Receipt, etc."
            />
            <TextField
              label="File URL"
              name="file_url"
              fullWidth
              value={form.file_url}
              onChange={handleFormChange}
              placeholder="https://..."
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDialog} disabled={saving}>
            Cancel
          </Button>
          <Button onClick={handleSave} variant="contained" disabled={saving}>
            {saving ? "Saving..." : "Add document"}
          </Button>
        </DialogActions>
      </Dialog>
    </AppLayout>
  );
}

export default DocumentsPage;
