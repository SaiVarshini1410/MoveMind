import { db } from "../db.js";

const userOwnsBox = (boxId, userId) =>
  new Promise((resolve, reject) => {
    const q = `
      SELECT b.id
      FROM boxes b
      JOIN rooms r ON r.id = b.room_id
      JOIN moves m ON m.id = r.move_id
      WHERE b.id = ? AND m.user_id = ?
      LIMIT 1
    `;
    db.query(q, [boxId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });

export const listItemsByBox = async (req, res) => {
  const { boxId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const q = `
      SELECT i.id, i.box_id, i.name, i.quantity, i.value
      FROM items i
      WHERE i.box_id = ?
      ORDER BY i.id DESC
    `;
    db.query(q, [boxId], (err, rows) =>
      err ? res.status(500).json({ error: err.message }) : res.json(rows)
    );
  } catch (e) { res.status(500).json({ error: e.message }); }
};

export const createItem = async (req, res) => {
  const { boxId } = req.params;
  const { name, quantity = 1, value = null } = req.body;
  if (!name) return res.status(400).json({ message: "name is required" });

  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const q = `
      INSERT INTO items (box_id, name, quantity, value)
      VALUES (?, ?, ?, ?)
    `;
    db.query(q, [boxId, name, quantity, value], (err, result) =>
      err
        ? res.status(500).json({ error: err.message })
        : res.status(201).json({ id: result.insertId, message: "Item created" })
    );
  } catch (e) { res.status(500).json({ error: e.message }); }
};

export const getItem = (req, res) => {
  const { itemId } = req.params;
  const q = `
    SELECT i.id, i.box_id, i.name, i.quantity, i.value
    FROM items i
    JOIN boxes b ON b.id = i.box_id
    JOIN rooms r ON r.id = b.room_id
    JOIN moves m ON m.id = r.move_id
    WHERE i.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [itemId, req.user.id], (err, rows) =>
    err
      ? res.status(500).json({ error: err.message })
      : rows.length ? res.json(rows[0]) : res.status(404).json({ message: "Item not found" })
  );
};

export const updateItem = (req, res) => {
  const { itemId } = req.params;
  const { name, quantity, value } = req.body;

  const check = `
    SELECT i.id
    FROM items i
    JOIN boxes b ON b.id = i.box_id
    JOIN rooms r ON r.id = b.room_id
    JOIN moves m ON m.id = r.move_id
    WHERE i.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [itemId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Item not found" });

    const fields = [], params = [];
    if (name !== undefined)     { fields.push("name = ?");     params.push(name); }
    if (quantity !== undefined) { fields.push("quantity = ?"); params.push(quantity); }
    if (value !== undefined)    { fields.push("value = ?");    params.push(value); }
    if (!fields.length) return res.status(400).json({ message: "No fields to update" });

    const q2 = `UPDATE items SET ${fields.join(", ")} WHERE id = ? LIMIT 1`;
    params.push(itemId);
    db.query(q2, params, (err2) =>
      err2 ? res.status(500).json({ error: err2.message }) : res.json({ message: "Item updated" })
    );
  });
};

export const deleteItem = (req, res) => {
  const { itemId } = req.params;
  const check = `
    SELECT i.id
    FROM items i
    JOIN boxes b ON b.id = i.box_id
    JOIN rooms r ON r.id = b.room_id
    JOIN moves m ON m.id = r.move_id
    WHERE i.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [itemId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Item not found" });

    db.query("DELETE FROM items WHERE id = ? LIMIT 1", [itemId], (err2) =>
      err2 ? res.status(500).json({ error: err2.message }) : res.json({ message: "Item deleted" })
    );
  });
};
