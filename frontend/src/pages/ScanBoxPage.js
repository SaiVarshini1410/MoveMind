import React, { useEffect, useState } from "react";
import {
  Box,
  Typography,
  Paper,
  CircularProgress,
  Alert,
  List,
  ListItem,
  ListItemText,
  Chip
} from "@mui/material";
import { useParams } from "react-router-dom";

import AppLayout from "../components/layout/AppLayout";
import apiClient from "../api/apiClient";

function ScanBoxPage() {
  const { labelCode } = useParams();

  const [box, setBox] = useState(null);
  const [items, setItems] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadData = async () => {
    setLoading(true);
    setError("");

    try {

      const boxRes = await apiClient.get(`/boxes/scan/${labelCode}`);
      const boxData = boxRes.data;
      setBox(boxData);


      const itemsRes = await apiClient.get(`/boxes/${boxData.id}/items`);
      setItems(itemsRes.data || []);
    } catch (err) {
      console.error("Error scanning box:", err);
      const msg =
        err.response?.data?.message ||
        err.response?.data?.error ||
        "Failed to load box data.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (labelCode) {
      loadData();
    }
  }, [labelCode]);

  return (
    <AppLayout title="Scan box">
      <Box sx={{ maxWidth: 700, mx: "auto", mt: 4 }}>
        <Typography variant="h4" gutterBottom>
          Box details
        </Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
          Label code: <strong>{labelCode}</strong>
        </Typography>

        {loading ? (
          <Box sx={{ display: "flex", justifyContent: "center", mt: 4 }}>
            <CircularProgress />
          </Box>
        ) : error ? (
          <Alert severity="error">{error}</Alert>
        ) : !box ? (
          <Alert severity="warning">Box not found.</Alert>
        ) : (
          <Paper
            sx={{
              p: 3,
              bgcolor: "#020617",
              borderRadius: 3,
              border: "1px solid #111827",
              display: "flex",
              flexDirection: "column",
              gap: 2
            }}
          >
            <Box
              sx={{
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                flexWrap: "wrap",
                gap: 1
              }}
            >
              <Typography variant="h6" sx={{ color: "#F9FAFB" }}>
                {box.label_code}
              </Typography>
              <Chip
                label={box.status}
                size="small"
                sx={{ textTransform: "capitalize" }}
              />
            </Box>

            <Typography variant="body2" sx={{ color: "text.secondary" }}>
              Weight: {box.weight != null ? `${box.weight}` : "—"}
            </Typography>

            <Typography variant="subtitle1" sx={{ mt: 1 }}>
              Items in this box
            </Typography>

            {items.length === 0 ? (
              <Typography
                variant="body2"
                sx={{ color: "text.secondary", fontStyle: "italic" }}
              >
                No items recorded for this box yet.
              </Typography>
            ) : (
              <List dense>
                {items.map((item) => (
                  <ListItem key={item.id} disableGutters>
                    <ListItemText
                      primary={item.name}
                      secondary={
                        item.quantity
                          ? `Quantity: ${item.quantity}${
                              item.value != null ? ` • Value: ${item.value}` : ""
                            }`
                          : item.value != null
                          ? `Value: ${item.value}`
                          : null
                      }
                    />
                  </ListItem>
                ))}
              </List>
            )}
          </Paper>
        )}
      </Box>
    </AppLayout>
  );
}

export default ScanBoxPage;
