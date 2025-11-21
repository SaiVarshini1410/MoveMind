import { db } from "../db.js";


const userOwnsMove = (moveId, userId) =>
  new Promise((resolve, reject) => {
    const q = "SELECT id FROM moves WHERE id = ? AND user_id = ? LIMIT 1";
    db.query(q, [moveId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });


export const listDocumentsByMove = async (req, res) => {
  const { moveId } = req.params;
  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = `
      SELECT id, doc_type, file_url, uploaded_on
      FROM documents
      WHERE move_id = ?
      ORDER BY uploaded_on DESC
    `;
    db.query(q, [moveId], (err, rows) =>
      err ? res.status(500).json({ error: err.message }) : res.json(rows)
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const createDocument = async (req, res) => {
  const { moveId } = req.params;
  const { doc_type, file_url } = req.body;

  if (!doc_type || !file_url)
    return res.status(400).json({ message: "doc_type and file_url are required" });

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = `
      INSERT INTO documents (move_id, doc_type, file_url)
      VALUES (?, ?, ?)
    `;
    db.query(q, [moveId, doc_type, file_url], (err, result) =>
      err
        ? res.status(500).json({ error: err.message })
        : res.status(201).json({ id: result.insertId, message: "Document added" })
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const deleteDocument = async (req, res) => {
  const { docId } = req.params;

  const q = `
    DELETE d
    FROM documents d
    JOIN moves m ON m.id = d.move_id
    WHERE d.id = ? AND m.user_id = ?
  `;
  db.query(q, [docId, req.user.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Document not found" });
    res.json({ message: "Document deleted" });
  });
};
