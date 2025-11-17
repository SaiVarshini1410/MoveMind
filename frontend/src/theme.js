import { createTheme } from "@mui/material/styles";

const theme = createTheme({
  palette: {
    mode: "dark",
    primary: {
      main: "#22D3EE"
    },
    secondary: {
      main: "#A855F7"
    },
    background: {
      default: "#020617", 
      paper: "#020617" 
    },
    text: {
      primary: "#F9FAFB",
      secondary: "#9CA3AF" 
    }
  },
  shape: {
    borderRadius: 10
  }
});

export default theme;
