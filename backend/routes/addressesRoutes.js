import express from "express";
import { listAddresses, createAddress } from "../controllers/addressesController.js";
import { requireAuth } from "../middleware/authMiddleware.js";

const router = express.Router();


router.use(requireAuth);


router.get("/", listAddresses);


router.post("/", createAddress);

export default router;
