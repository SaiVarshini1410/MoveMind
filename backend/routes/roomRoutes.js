import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listRooms,
  createRoom,
  updateRoom,
  deleteRoom
} from "../controllers/roomsController.js";

const router = express.Router();

router.use(requireAuth);

router.get("/moves/:moveId/rooms", listRooms);
router.post("/moves/:moveId/rooms", createRoom);
router.patch("/moves/:moveId/rooms/:roomName", updateRoom);
router.delete("/moves/:moveId/rooms/:roomName", deleteRoom);

export default router;
