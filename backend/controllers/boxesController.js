import { db } from "../db.js";

const ALLOWED_STATUS = new Set([
  "empty",
  "packed",
  "loaded",
  "delivered",
  "unpacked"
]);

const userOwnsRoom = (moveId, roomName, userId) =>
  new Promise((resolve, reject) => {
    const q = `
      SELECT r.move_id, r.name
      FROM rooms r
      JOIN moves m ON m.id = r.move_id
      WHERE r.move_id = ? AND r.name = ? AND m.user_id = ?
      LIMIT 1
    `;
    db.query(q, [moveId, roomName, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });

export const listBoxesByRoom = async (req, res) => {
  const { moveId, roomName } = req.params;
  const { status } = req.query;

  try {
    const ownsRoom = await userOwnsRoom(Number(moveId), roomName, req.user.id);
    if (!ownsRoom) return res.status(404).json({ message: "Room not found" });

    const where = ["b.move_id = ?", "b.room_name = ?"];
    const params = [moveId, roomName];

    if (status) {
      if (!ALLOWED_STATUS.has(status)) {
        return res.status(400).json({ message: "Invalid status" });
      }
      where.push("b.status = ?");
      params.push(status);
    }

    const q = `
      SELECT b.id, b.move_id, b.room_name, b.label_code, b.fragile, b.weight, b.status
      FROM boxes b
      WHERE ${where.join(" AND ")}
      ORDER BY b.id DESC
    `;
    db.query(q, params, (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const createBox = async (req, res) => {
  const { moveId, roomName } = req.params;
  const { label_code, fragile = 0, weight = null, status = "empty" } = req.body;

  if (!label_code) {
    return res.status(400).json({ message: "label_code is required" });
  }

  if (!ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    const ownsRoom = await userOwnsRoom(Number(moveId), roomName, req.user.id);
    if (!ownsRoom) return res.status(404).json({ message: "Room not found" });

    const q = `
      INSERT INTO boxes (move_id, room_name, label_code, fragile, weight, status)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    db.query(
      q,
      [moveId, roomName, label_code, fragile ? 1 : 0, weight, status],
      (err, result) => {
        if (err) {
          if (err.code === "ER_DUP_ENTRY") {
            return res
              .status(400)
              .json({ message: "label_code must be unique" });
          }
          return res.status(500).json({ error: err.message });
        }
        res
          .status(201)
          .json({ id: result.insertId, message: "Box created" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const getBox = (req, res) => {
  const { boxId } = req.params;
  const q = `
    SELECT b.id, b.move_id, b.room_name, b.label_code, b.fragile, b.weight, b.status
    FROM boxes b
    JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
    JOIN moves m ON m.id = r.move_id
    WHERE b.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [boxId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Box not found" });
    res.json(rows[0]);
  });
};

export const updateBox = (req, res) => {
  const { boxId } = req.params;
  const { label_code, fragile, weight, status } = req.body;

  if (status && !ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  const check = `
    SELECT b.id
    FROM boxes b
    JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
    JOIN moves m ON m.id = r.move_id
    WHERE b.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [boxId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Box not found" });

    const fields = [];
    const params = [];

    if (label_code !== undefined) {
      fields.push("label_code = ?");
      params.push(label_code);
    }
    if (fragile !== undefined) {
      fields.push("fragile = ?");
      params.push(fragile ? 1 : 0);
    }
    if (weight !== undefined) {
      fields.push("weight = ?");
      params.push(weight);
    }
    if (status !== undefined) {
      fields.push("status = ?");
      params.push(status);
    }

    if (!fields.length) {
      return res.status(400).json({ message: "No fields to update" });
    }

    const q2 = `UPDATE boxes SET ${fields.join(", ")} WHERE id = ? LIMIT 1`;
    params.push(boxId);

    db.query(q2, params, (err2) => {
      if (err2) {
        if (err2.code === "ER_DUP_ENTRY") {
          return res
            .status(400)
            .json({ message: "label_code must be unique" });
        }
        return res.status(500).json({ error: err2.message });
      }
      res.json({ message: "Box updated" });
    });
  });
};

export const deleteBox = (req, res) => {
  const { boxId } = req.params;

  const check = `
    SELECT b.id
    FROM boxes b
    JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
    JOIN moves m ON m.id = r.move_id
    WHERE b.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [boxId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Box not found" });

    db.query("DELETE FROM boxes WHERE id = ? LIMIT 1", [boxId], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: "Box deleted" });
    });
  });
};

export const scanByLabel = (req, res) => {
  const { labelCode } = req.params;
  const q = `
    SELECT b.id, b.move_id, b.room_name, b.label_code, b.fragile, b.weight, b.status
    FROM boxes b
    JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
    JOIN moves m ON m.id = r.move_id
    WHERE b.label_code = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [labelCode, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "Box not found" });
    res.json(rows[0]);
  });
};
