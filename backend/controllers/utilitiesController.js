import { db } from "../db.js";


export const listUtilities = (_req, res) => {
  const q = `
    SELECT id, provider_name, type
    FROM utilities
    ORDER BY provider_name ASC
  `;
  db.query(q, (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
};


const ALLOWED_TYPES = new Set([
  "electricity",
  "gas",
  "water",
  "internet",
  "trash",
  "other"
]);

export const createUtility = (req, res) => {
  const { provider_name, type } = req.body;

  if (!provider_name || !type) {
    return res.status(400).json({ message: "provider_name and type are required" });
  }
  if (!ALLOWED_TYPES.has(type)) {
    return res.status(400).json({ message: "Invalid type" });
  }

  const q = `
    INSERT INTO utilities (provider_name, type)
    VALUES (?, ?)
  `;
  db.query(q, [provider_name, type], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ id: result.insertId, message: "Utility created" });
  });
};


export const updateUtility = (req, res) => {
  const { utilityId } = req.params;
  const { provider_name, type } = req.body;

  const fields = [];
  const params = [];

  if (provider_name !== undefined) {
    fields.push("provider_name = ?");
    params.push(provider_name);
  }
  if (type !== undefined) {
    if (!ALLOWED_TYPES.has(type)) {
      return res.status(400).json({ message: "Invalid type" });
    }
    fields.push("type = ?");
    params.push(type);
  }

  if (!fields.length) {
    return res.status(400).json({ message: "No fields to update" });
  }

  const q = `
    UPDATE utilities
    SET ${fields.join(", ")}
    WHERE id = ?
    LIMIT 1
  `;
  params.push(utilityId);

  db.query(q, params, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!result.affectedRows) {
      return res.status(404).json({ message: "Utility not found" });
    }
    res.json({ message: "Utility updated" });
  });
};


export const deleteUtility = (req, res) => {
  const { utilityId } = req.params;

  const q = "DELETE FROM utilities WHERE id = ? LIMIT 1";
  db.query(q, [utilityId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!result.affectedRows) {
      return res.status(404).json({ message: "Utility not found" });
    }
    res.json({ message: "Utility deleted" });
  });
};
