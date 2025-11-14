import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listUtilitiesForMove,
  addUtilityToMove,
  getMoveUtility,
  updateMoveUtility,
  deleteMoveUtility
} from "../controllers/moveUtilitiesController.js";

const router = express.Router();

router.use(requireAuth);


router.get("/moves/:moveId/utilities", listUtilitiesForMove);
router.post("/moves/:moveId/utilities", addUtilityToMove);


router.get("/move-utilities/:id", getMoveUtility);
router.patch("/move-utilities/:id", updateMoveUtility);
router.delete("/move-utilities/:id", deleteMoveUtility);

export default router;
