import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listBoxesByRoom,
  createBox,
  getBox,
  updateBox,
  deleteBox,
  scanByLabel
} from "../controllers/boxesController.js";

const router = express.Router();


router.use(requireAuth);


router.get("/rooms/:roomId/boxes", listBoxesByRoom);
router.post("/rooms/:roomId/boxes", createBox);


router.get("/boxes/:boxId", getBox);
router.patch("/boxes/:boxId", updateBox);
router.delete("/boxes/:boxId", deleteBox);


router.get("/boxes/scan/:labelCode", scanByLabel);

export default router;
