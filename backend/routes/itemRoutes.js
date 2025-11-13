import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listItemsByBox, createItem, getItem, updateItem, deleteItem
} from "../controllers/itemsController.js";

const router = express.Router();
router.use(requireAuth);

router.get("/boxes/:boxId/items", listItemsByBox);
router.post("/boxes/:boxId/items", createItem);

router.get("/items/:itemId", getItem);
router.patch("/items/:itemId", updateItem);
router.delete("/items/:itemId", deleteItem);

export default router;
