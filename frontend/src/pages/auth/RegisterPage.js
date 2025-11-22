import React, { useState } from "react";
import {
  Box,
  Paper,
  TextField,
  Button,
  Typography,
  Link,
  Alert
} from "@mui/material";
import { useNavigate, Link as RouterLink } from "react-router-dom";
import apiClient from "../../api/apiClient";

function RegisterPage() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    first_name: "",
    last_name: "",
    email: "",
    password: ""
  });
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      await apiClient.post("/auth/register", form);
      alert("Registration successful! Please log in.");
      navigate("/login");
    } catch (err) {
      console.error("Register error:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Registration failed. Please try again.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ display: "flex", minHeight: "100vh" }}>
      <Box
        sx={{
          flex: 1,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          p: 4,
          background:
            "linear-gradient(135deg, #020617 0%, #111827 50%, #22D3EE 100%)",
          color: "#F9FAFB"
        }}
      >
        <Box sx={{ maxWidth: 420 }}>
          <Typography variant="h3" sx={{ mb: 2 }}>
            MoveMind
          </Typography>
          <Typography variant="h5" sx={{ mb: 2 }}>
            Plan your move like a pro.
          </Typography>
          <Typography variant="body1" sx={{ opacity: 0.85 }}>
            Create an account to start tracking moves, rooms, boxes, utilities,
            appointments, and documents in one place.
          </Typography>
        </Box>
      </Box>

      <Box
        sx={{
          flex: 1,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          bgcolor: "background.default",
          p: 4
        }}
      >
        <Paper
          elevation={6}
          sx={{
            p: 4,
            width: "100%",
            maxWidth: 420,
            bgcolor: "#020617",
            borderRadius: 3,
            border: "1px solid #111827"
          }}
        >
          <Typography variant="h5" component="h1" gutterBottom align="center">
            Create your account
          </Typography>
          <Typography
            variant="body2"
            align="center"
            sx={{ mb: 2, color: "text.secondary" }}
          >
            Sign up to start organizing your move.
          </Typography>

          {error && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {error}
            </Alert>
          )}

          <Box component="form" onSubmit={handleSubmit}>
            <TextField
              fullWidth
              label="First name"
              name="first_name"
              margin="normal"
              value={form.first_name}
              onChange={handleChange}
              required
            />

            <TextField
              fullWidth
              label="Last name"
              name="last_name"
              margin="normal"
              value={form.last_name}
              onChange={handleChange}
              required
            />

            <TextField
              fullWidth
              label="Email"
              name="email"
              type="email"
              margin="normal"
              value={form.email}
              onChange={handleChange}
              required
            />

            <TextField
              fullWidth
              label="Password"
              name="password"
              type="password"
              margin="normal"
              value={form.password}
              onChange={handleChange}
              required
            />

            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
              disabled={loading}
            >
              {loading ? "Signing up..." : "Sign Up"}
            </Button>

            <Typography
              variant="body2"
              align="center"
              sx={{ color: "text.secondary" }}
            >
              Already have an account?{" "}
              <Link component={RouterLink} to="/login">
                Log in
              </Link>
            </Typography>
          </Box>
        </Paper>
      </Box>
    </Box>
  );
}

export default RegisterPage;
