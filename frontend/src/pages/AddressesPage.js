import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  TextField,
  Button,
  Alert,
  CircularProgress,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody
} from "@mui/material";
import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

function AddressesPage() {
  const [addresses, setAddresses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [form, setForm] = useState({
    label: "",
    line1: "",
    line2: "",
    city: "",
    state: "",
    postal_code: "",
    country: ""
  });
  const [saving, setSaving] = useState(false);
  const [formError, setFormError] = useState("");
  const [formSuccess, setFormSuccess] = useState("");

  const fetchAddresses = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await apiClient.get("/addresses");
      setAddresses(res.data || []);
    } catch (err) {
      console.error("Error fetching addresses:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load addresses.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAddresses();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({
      ...prev,
      [name]: value
    }));
  };

  const handleCreate = async (e) => {
    e.preventDefault();
    setFormError("");
    setFormSuccess("");

    const { label, line1, city, state, postal_code, country } = form;
    if (!label || !line1 || !city || !state || !postal_code || !country) {
      setFormError("Please fill in all required fields (*).");
      return;
    }

    setSaving(true);
    try {
      await apiClient.post("/addresses", {
        label: form.label,
        line1: form.line1,
        line2: form.line2 || null,
        city: form.city,
        state: form.state,
        postal_code: form.postal_code,
        country: form.country
      });

      setFormSuccess("Address added.");
      setFormError("");
      setForm({
        label: "",
        line1: "",
        line2: "",
        city: "",
        state: "",
        postal_code: "",
        country: ""
      });

      await fetchAddresses();
    } catch (err) {
      console.error("Error creating address:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to create address.";
      setFormError(msg);
      setFormSuccess("");
    } finally {
      setSaving(false);
    }
  };

  return (
    <AppLayout title="Addresses">
      <Box sx={{ mb: 3 }}>
        <Typography variant="h4" gutterBottom>
          Addresses
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Add simple from / to addresses that you can reuse when creating moves.
        </Typography>
      </Box>


      <Paper
        sx={{
          mb: 4,
          p: 2,
          bgcolor: "#020617",
          borderRadius: 2,
          border: "1px solid #111827"
        }}
      >
        <Typography variant="h6" sx={{ mb: 2 }}>
          Add new address
        </Typography>

        {formError && (
          <Alert severity="error" sx={{ mb: 2 }}>
            {formError}
          </Alert>
        )}

        {formSuccess && (
          <Alert severity="success" sx={{ mb: 2 }}>
            {formSuccess}
          </Alert>
        )}

        <Box
          component="form"
          onSubmit={handleCreate}
          sx={{
            display: "grid",
            gridTemplateColumns: { xs: "1fr", sm: "1fr 1fr" },
            gap: 2
          }}
        >
          <TextField
            label="Label *"
            name="label"
            value={form.label}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="Country *"
            name="country"
            value={form.country}
            onChange={handleChange}
            fullWidth
          />

          <TextField
            label="Address line 1 *"
            name="line1"
            value={form.line1}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="Address line 2"
            name="line2"
            value={form.line2}
            onChange={handleChange}
            fullWidth
          />

          <TextField
            label="City *"
            name="city"
            value={form.city}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="State *"
            name="state"
            value={form.state}
            onChange={handleChange}
            fullWidth
          />

          <TextField
            label="Postal code *"
            name="postal_code"
            value={form.postal_code}
            onChange={handleChange}
            fullWidth
          />
        </Box>

        <Box sx={{ mt: 2, display: "flex", justifyContent: "flex-end" }}>
          <Button
            type="submit"
            variant="contained"
            onClick={handleCreate}
            disabled={saving}
          >
            {saving ? "Saving..." : "Save address"}
          </Button>
        </Box>
      </Paper>

      {loading ? (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 4 }}>
          <CircularProgress />
        </Box>
      ) : error ? (
        <Alert severity="error">{error}</Alert>
      ) : (
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
                <TableCell sx={{ color: "#E5E7EB" }}>Label</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Address</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>City</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>State</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Postal code</TableCell>
                <TableCell sx={{ color: "#E5E7EB" }}>Country</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {addresses.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} sx={{ color: "text.secondary" }}>
                    No addresses yet. Add one above to get started.
                  </TableCell>
                </TableRow>
              ) : (
                addresses.map((addr) => (
                  <TableRow key={addr.id} hover>
                    <TableCell sx={{ color: "#F9FAFB" }}>
                      {addr.label}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {addr.line1}
                      {addr.line2 ? `, ${addr.line2}` : ""}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {addr.city}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {addr.state}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {addr.postal_code}
                    </TableCell>
                    <TableCell sx={{ color: "text.secondary" }}>
                      {addr.country}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </Paper>
      )}
    </AppLayout>
  );
}

export default AddressesPage;
