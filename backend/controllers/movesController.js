import { db } from "../db.js";


const ALLOWED_STATUS = new Set([
  "planned", "packing", "in_transit", "unpacking", "done"
]);


const addressesExist = (fromId, toId) =>
  new Promise((resolve, reject) => {
    db.query(
      "SELECT id FROM addresses WHERE id IN (?, ?)",
      [fromId, toId],
      (err, rows) => {
        if (err) return reject(err);
        resolve(rows.length === 2);
      }
    );
  });


export const listMoves = (req, res) => {
  const q = `
    SELECT id, title, move_date, status, created_at, from_address_id, to_address_id
    FROM moves
    WHERE user_id = ?
    ORDER BY created_at DESC
  `;
  db.query(q, [req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
};

export const getMove = (req, res) => {
  const { id } = req.params;
  const q = `
    SELECT id, title, move_date, status, created_at, from_address_id, to_address_id
    FROM moves
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `;
  db.query(q, [id, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Move not found" });
    res.json(rows[0]);
  });
};

export const createMove = async (req, res) => {
  try {
    const { title, move_date, status = "planned", from_address_id, to_address_id } = req.body;

    if (!title || !from_address_id || !to_address_id)
      return res.status(400).json({ message: "title, from_address_id, to_address_id are required" });

    if (!ALLOWED_STATUS.has(status))
      return res.status(400).json({ message: "Invalid status" });

    const ok = await addressesExist(from_address_id, to_address_id);
    if (!ok) return res.status(400).json({ message: "Invalid address ids" });

    const q = `
      INSERT INTO moves (user_id, title, move_date, status, from_address_id, to_address_id)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    db.query(
      q,
      [req.user.id, title, move_date || null, status, from_address_id, to_address_id],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ id: result.insertId, message: "Move created" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateMove = async (req, res) => {
  const { id } = req.params;
  const { title, move_date, status, from_address_id, to_address_id } = req.body;


  if (status && !ALLOWED_STATUS.has(status))
    return res.status(400).json({ message: "Invalid status" });


  if ((from_address_id && !Number.isInteger(from_address_id)) ||
      (to_address_id && !Number.isInteger(to_address_id))) {
    return res.status(400).json({ message: "Address ids must be integers" });
  }


  if (from_address_id || to_address_id) {
    const fromId = from_address_id ?? -1;
    const toId = to_address_id ?? -1;
    const ok = await addressesExist(fromId, toId);

    if (from_address_id && !ok) {
      let singleOk = await addressesExist(from_address_id, from_address_id);
      if (!singleOk) return res.status(400).json({ message: "Invalid from_address_id" });
    }
    if (to_address_id && !ok) {
      let singleOk = await addressesExist(to_address_id, to_address_id);
      if (!singleOk) return res.status(400).json({ message: "Invalid to_address_id" });
    }
  }


  const fields = [];
  const params = [];
  if (title !== undefined) { fields.push("title = ?"); params.push(title); }
  if (move_date !== undefined) { fields.push("move_date = ?"); params.push(move_date || null); }
  if (status !== undefined) { fields.push("status = ?"); params.push(status); }
  if (from_address_id !== undefined) { fields.push("from_address_id = ?"); params.push(from_address_id); }
  if (to_address_id !== undefined) { fields.push("to_address_id = ?"); params.push(to_address_id); }

  if (!fields.length) return res.status(400).json({ message: "No fields to update" });

  const q = `
    UPDATE moves
    SET ${fields.join(", ")}
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `;
  params.push(id, req.user.id);

  db.query(q, params, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) return res.status(404).json({ message: "Move not found" });
    res.json({ message: "Move updated" });
  });
};

export const deleteMove = (req, res) => {
  const { id } = req.params;

  const q = "DELETE FROM moves WHERE id = ? AND user_id = ? LIMIT 1";
  db.query(q, [id, req.user.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) return res.status(404).json({ message: "Move not found" });
    res.json({ message: "Move deleted" });
  });
};
