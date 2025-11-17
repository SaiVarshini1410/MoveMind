import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import {db} from './db.js';
import sampleRoutes from './routes/sampleRoutes.js';
import authRoutes from "./routes/authRoutes.js";
import moveRoutes from "./routes/moveRoutes.js";
import roomRoutes from "./routes/roomRoutes.js";
import boxRoutes from "./routes/boxRoutes.js";
import itemRoutes from "./routes/itemRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js";
import boxCategoryRoutes from "./routes/boxCategoryRoutes.js";
import documentRoutes from "./routes/documentRoutes.js";
import appointmentRoutes from "./routes/appointmentRoutes.js";
import utilityRoutes from "./routes/utilityRoutes.js";
import moveUtilityRoutes from "./routes/moveUtilityRoutes.js";
import addressesRoutes from "./routes/addressesRoutes.js";


dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/sample", sampleRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/moves", moveRoutes);
app.use("/api", roomRoutes);
app.use("/api", boxRoutes);
app.use("/api", itemRoutes);
app.use("/api", categoryRoutes);
app.use("/api", boxCategoryRoutes);
app.use("/api", documentRoutes);
app.use("/api", appointmentRoutes);
app.use("/api", utilityRoutes);
app.use("/api", moveUtilityRoutes);
app.use("/api/addresses", addressesRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {console.log(`Server running on port ${PORT}`)});
