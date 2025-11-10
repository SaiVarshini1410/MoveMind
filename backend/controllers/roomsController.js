import { db } from "../db.js";


const userOwnsMove = (moveId, userId) =>
  new Promise((resolve, reject) => {
    const q = "SELECT id FROM moves WHERE id = ? AND user_id = ? LIMIT 1";
    db.query(q, [moveId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });


export const listRooms = async (req, res) => {
  const { moveId } = req.params;
  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = "SELECT id, move_id, name, floor FROM rooms WHERE move_id = ? ORDER BY id DESC";
    db.query(q, [moveId], (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const createRoom = async (req, res) => {
  const { moveId } = req.params;
  const { name, floor } = req.body;

  if (!name) return res.status(400).json({ message: "name is required" });

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = "INSERT INTO rooms (move_id, name, floor) VALUES (?, ?, ?)";
    db.query(q, [moveId, name, floor || null], (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ id: result.insertId, message: "Room created" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const updateRoom = (req, res) => {
  const { roomId } = req.params;
  const { name, floor } = req.body;


  const check = `
    SELECT r.id
    FROM rooms r
    JOIN moves m ON m.id = r.move_id
    WHERE r.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [roomId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Room not found" });

    
    const fields = [];
    const params = [];
    if (name !== undefined) { fields.push("name = ?"); params.push(name); }
    if (floor !== undefined) { fields.push("floor = ?"); params.push(floor || null); }

    if (!fields.length) return res.status(400).json({ message: "No fields to update" });

    const q = `UPDATE rooms SET ${fields.join(", ")} WHERE id = ? LIMIT 1`;
    params.push(roomId);

    db.query(q, params, (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: "Room updated" });
    });
  });
};


export const deleteRoom = (req, res) => {
  const { roomId } = req.params;

  const check = `
    SELECT r.id
    FROM rooms r
    JOIN moves m ON m.id = r.move_id
    WHERE r.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [roomId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Room not found" });

    const q = "DELETE FROM rooms WHERE id = ? LIMIT 1";
    db.query(q, [roomId], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: "Room deleted" });
    });
  });
};
