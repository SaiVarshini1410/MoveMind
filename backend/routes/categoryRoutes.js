import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listCategories, createCategory, updateCategory, deleteCategory
} from "../controllers/categoriesController.js";

const router = express.Router();

router.use(requireAuth);

router.get("/categories", listCategories);
router.post("/categories", createCategory);
router.patch("/categories/:categoryId", updateCategory);
router.delete("/categories/:categoryId", deleteCategory);

export default router;
