import { db } from "../db.js";

export const listDocumentsByMove = (req, res) => {
  const { moveId } = req.params;

  const q = "CALL sp_list_documents_for_user_move(?, ?)";
  db.query(q, [moveId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });

    const ownsRows =
      Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
    const ownsRow = ownsRows[0];
    const owns =
      ownsRow && (ownsRow.owns === 1 || ownsRow.owns === true || ownsRow.owns === "1");

    if (!owns) {
      return res.status(404).json({ message: "Move not found" });
    }

    const docsRows =
      Array.isArray(rows) && Array.isArray(rows[1]) ? rows[1] : [];

    res.json(docsRows || []);
  });
};

export const createDocument = (req, res) => {
  const { moveId } = req.params;
  const { doc_type, file_url } = req.body;

  if (!doc_type || !file_url) {
    return res
      .status(400)
      .json({ message: "doc_type and file_url are required" });
  }

  const q = "CALL sp_create_document_for_user(?, ?, ?, ?)";
  db.query(q, [moveId, req.user.id, doc_type, file_url], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });

    const resultRows =
      Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
    const row = resultRows[0];

    if (!row || !row.success) {
      const status = row && row.message === "Move not found" ? 404 : 400;
      return res
        .status(status)
        .json({ message: row?.message || "Failed to create document" });
    }

    return res
      .status(201)
      .json({ id: row.id, message: row.message || "Document added" });
  });
};

export const deleteDocument = (req, res) => {
  const { docId } = req.params;

  const q = "CALL sp_delete_document(?, ?)";
  db.query(q, [docId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });

    const resultRows =
      Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
    const row = resultRows[0];

    if (!row || !row.success) {
      return res
        .status(404)
        .json({ message: row?.message || "Document not found" });
    }

    res.json({ message: row.message || "Document deleted" });
  });
};
