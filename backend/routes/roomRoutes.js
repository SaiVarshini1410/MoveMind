import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listRooms, createRoom, updateRoom, deleteRoom
} from "../controllers/roomsController.js";

const router = express.Router();


router.use(requireAuth);


router.get("/moves/:moveId/rooms", listRooms);
router.post("/moves/:moveId/rooms", createRoom);


router.patch("/rooms/:roomId", updateRoom);
router.delete("/rooms/:roomId", deleteRoom);

export default router;
