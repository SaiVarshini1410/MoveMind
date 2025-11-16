import React from "react";
import { Container, Typography } from "@mui/material";

function DashboardPage() {
  return (
    <Container sx={{ mt: 4 }}>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      <Typography variant="body1">
        This is the MoveMind dashboard.
      </Typography>
    </Container>
  );
}

export default DashboardPage;
