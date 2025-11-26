import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listUtilitiesForMove,
  addUtilityToMove,
  updateMoveUtility,
  deleteMoveUtility
} from "../controllers/moveUtilitiesController.js";

const router = express.Router();

router.use(requireAuth);

router.get("/moves/:moveId/utilities", listUtilitiesForMove);
router.post("/moves/:moveId/utilities", addUtilityToMove);
router.patch("/moves/:moveId/utilities/:utilityId", updateMoveUtility);
router.delete("/moves/:moveId/utilities/:utilityId", deleteMoveUtility);

export default router;
