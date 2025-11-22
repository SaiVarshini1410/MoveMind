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
import { saveAuth } from "../../utils/auth";

function LoginPage() {
  const navigate = useNavigate();

  const [form, setForm] = useState({ email: "", password: "" });
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
      const res = await apiClient.post("/auth/login", form);
      const { token, user } = res.data || {};
      if (!token || !user) {
        throw new Error("Invalid login response from server.");
      }
      saveAuth(token, user);
      navigate("/dashboard");
    } catch (err) {
      console.error("Login error:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Login failed. Please check your email and password.";
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
            Organize your move without chaos.
          </Typography>
          <Typography variant="body1" sx={{ opacity: 0.85 }}>
            Track rooms, boxes, appointments, utilities, and documents - all in
            one clean dashboard backed by a solid database design.
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
            Welcome back
          </Typography>
          <Typography
            variant="body2"
            align="center"
            sx={{ mb: 2, color: "text.secondary" }}
          >
            Log in to manage your moves.
          </Typography>

          {error && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {error}
            </Alert>
          )}

          <Box component="form" onSubmit={handleSubmit}>
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
              {loading ? "Logging in..." : "Log In"}
            </Button>

            <Typography
              variant="body2"
              align="center"
              sx={{ color: "text.secondary" }}
            >
              Don&apos;t have an account?{" "}
              <Link component={RouterLink} to="/register">
                Sign up
              </Link>
            </Typography>
          </Box>
        </Paper>
      </Box>
    </Box>
  );
}

export default LoginPage;
