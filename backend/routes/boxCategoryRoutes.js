import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listCategoriesForBox,
  attachCategoryToBox,
  detachCategoryFromBox
} from "../controllers/boxCategoryController.js";

const router = express.Router();

router.use(requireAuth);


router.get("/boxes/:boxId/categories", listCategoriesForBox);
router.post("/boxes/:boxId/categories/:categoryId", attachCategoryToBox);
router.delete("/boxes/:boxId/categories/:categoryId", detachCategoryFromBox);

export default router;
