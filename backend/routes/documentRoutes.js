import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listDocumentsByMove,
  createDocument,
  deleteDocument
} from "../controllers/documentsController.js";

const router = express.Router();
router.use(requireAuth);


router.get("/moves/:moveId/documents", listDocumentsByMove);
router.post("/moves/:moveId/documents", createDocument);


router.delete("/documents/:docId", deleteDocument);

export default router;
