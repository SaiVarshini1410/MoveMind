import React from "react";
import { Typography } from "@mui/material";
import AppLayout from "../components/layout/AppLayout";

function DashboardPage() {
  return (
    <AppLayout title="Dashboard">
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      <Typography variant="body1">
        This is the MoveMind dashboard.
      </Typography>
    </AppLayout>
  );
}

export default DashboardPage;
