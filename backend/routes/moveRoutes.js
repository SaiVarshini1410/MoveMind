import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listMoves, getMove, createMove, updateMove, deleteMove
} from "../controllers/movesController.js";

const router = express.Router();

router.use(requireAuth);


router.get("/", listMoves);


router.get("/:id", getMove);


router.post("/", createMove);


router.patch("/:id", updateMove);


router.delete("/:id", deleteMove);


export default router;
