// src/components/layout/AppLayout.js
import React from "react";
import {
  Box,
  Drawer,
  List,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
  AppBar,
  Typography,
  IconButton
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import DashboardIcon from "@mui/icons-material/Dashboard";
import LocalShippingIcon from "@mui/icons-material/LocalShipping";
import LocationOnIcon from "@mui/icons-material/LocationOn";
import LogoutIcon from "@mui/icons-material/Logout";
import EventNoteIcon from "@mui/icons-material/EventNote";
import { useLocation, useNavigate } from "react-router-dom";
import { clearAuth, getUser } from "../../utils/auth";

const drawerWidth = 240;

const navItems = [
  {
    label: "Dashboard",
    path: "/dashboard",
    icon: <DashboardIcon fontSize="small" />
  },
  {
    label: "Moves",
    path: "/moves",
    icon: <LocalShippingIcon fontSize="small" />
  },
  {
    label: "Addresses",
    path: "/addresses",
    icon: <LocationOnIcon fontSize="small" />
  },
  {
    label: "Appointments",
    path: "/appointments",
    icon: <EventNoteIcon fontSize="small" />
  }
];

function AppLayout({ title, children }) {
  const [mobileOpen, setMobileOpen] = React.useState(false);
  const location = useLocation();
  const navigate = useNavigate();

  const user = getUser();
  const displayName =
    user?.first_name || user?.firstName || user?.name || "User";

  const handleDrawerToggle = () => {
    setMobileOpen((prev) => !prev);
  };

  const handleLogout = () => {
    clearAuth();
    navigate("/login");
  };

  const drawer = (
    <Box
      sx={{
        height: "100%",
        display: "flex",
        flexDirection: "column",
        bgcolor: "#020617",
        color: "#E5E7EB"
      }}
    >
      {/* Logo / title */}
      <Box sx={{ p: 2, borderBottom: "1px solid #111827" }}>
        <Typography
          variant="h6"
          sx={{
            fontWeight: 700,
            letterSpacing: 0.5
          }}
        >
          MoveMind
        </Typography>
        <Typography variant="caption" color="text.secondary">
          Plan your next move
        </Typography>
      </Box>

      {/* Nav items */}
      <Box sx={{ flexGrow: 1, overflowY: "auto" }}>
        <List sx={{ mt: 1 }}>
          {navItems.map((item) => {
            const selected = location.pathname.startsWith(item.path);
            return (
              <ListItemButton
                key={item.path}
                selected={selected}
                onClick={() => {
                  navigate(item.path);
                  setMobileOpen(false);
                }}
                sx={{
                  mb: 0.5,
                  borderRadius: 2,
                  mx: 1,
                  "&.Mui-selected": {
                    bgcolor: "rgba(59,130,246,0.15)"
                  },
                  "&.Mui-selected:hover": {
                    bgcolor: "rgba(59,130,246,0.25)"
                  }
                }}
              >
                <ListItemIcon sx={{ color: "#9CA3AF", minWidth: 36 }}>
                  {item.icon}
                </ListItemIcon>
                <ListItemText
                  primary={item.label}
                  primaryTypographyProps={{
                    fontSize: 14
                  }}
                />
              </ListItemButton>
            );
          })}
        </List>
      </Box>

      {/* Logout */}
      <Box sx={{ p: 1.5, borderTop: "1px solid #111827" }}>
        <ListItemButton
          onClick={handleLogout}
          sx={{
            borderRadius: 2,
            "&:hover": { bgcolor: "rgba(239,68,68,0.08)" }
          }}
        >
          <ListItemIcon sx={{ color: "#F87171", minWidth: 36 }}>
            <LogoutIcon fontSize="small" />
          </ListItemIcon>
          <ListItemText
            primary="Logout"
            primaryTypographyProps={{ fontSize: 14 }}
          />
        </ListItemButton>
      </Box>
    </Box>
  );

  return (
    <Box sx={{ display: "flex", minHeight: "100vh", bgcolor: "#020617" }}>
      {/* Top App Bar */}
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
          bgcolor: "rgba(15,23,42,0.9)",
          backdropFilter: "blur(10px)",
          borderBottom: "1px solid #111827",
          boxShadow: "0 10px 30px rgba(0,0,0,0.4)"
        }}
      >
        <Toolbar>
          {/* Menu button (mobile) */}
          <IconButton
            color="inherit"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: "none" } }}
          >
            <MenuIcon />
          </IconButton>

          <Box sx={{ flexGrow: 1 }} />

          {user && (
            <Typography
              variant="body2"
              sx={{ mr: 1.5, color: "#E5E7EB", fontWeight: 1000 }}
            >
              {displayName} is Moving!
            </Typography>
          )}
        </Toolbar>
      </AppBar>

      {/* Sidebar drawer */}
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
        aria-label="navigation"
      >
        {/* Mobile drawer */}
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true
          }}
          sx={{
            display: { xs: "block", sm: "none" },
            "& .MuiDrawer-paper": {
              boxSizing: "border-box",
              width: drawerWidth
            }
          }}
        >
          {drawer}
        </Drawer>

        {/* Desktop drawer */}
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: "none", sm: "block" },
            "& .MuiDrawer-paper": {
              boxSizing: "border-box",
              width: drawerWidth
            }
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>

      {/* Main content */}
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          bgcolor:
            "radial-gradient(circle at top, #020617 0, #020617 30%, #000 80%)"
        }}
      >
        <Toolbar />
        {children}
      </Box>
    </Box>
  );
}

export default AppLayout;
