import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listUtilities,
  createUtility,
  updateUtility,
  deleteUtility
} from "../controllers/utilitiesController.js";

const router = express.Router();

router.use(requireAuth);


router.get("/utilities", listUtilities);
router.post("/utilities", createUtility);
router.patch("/utilities/:utilityId", updateUtility);
router.delete("/utilities/:utilityId", deleteUtility);

export default router;
