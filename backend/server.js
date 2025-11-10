import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import {db} from './db.js';
import sampleRoutes from './routes/sampleRoutes.js';
import authRoutes from "./routes/authRoutes.js";
import moveRoutes from "./routes/moveRoutes.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/sample", sampleRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/moves", moveRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {console.log(`Server running on port ${PORT}`)});
