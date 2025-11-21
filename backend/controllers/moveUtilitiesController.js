import { db } from "../db.js";

const ALLOWED_STATUSES = new Set([
  "planned",
  "requested",
  "confirmed",
  "active",
  "cancelled"
]);


const userOwnsMove = (moveId, userId) =>
  new Promise((resolve, reject) => {
    const q = "SELECT id FROM moves WHERE id = ? AND user_id = ? LIMIT 1";
    db.query(q, [moveId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });


const utilityExists = (utilityId) =>
  new Promise((resolve, reject) => {
    db.query(
      "SELECT id FROM utilities WHERE id = ? LIMIT 1",
      [utilityId],
      (err, rows) => {
        if (err) return reject(err);
        resolve(rows.length === 1);
      }
    );
  });


export const listUtilitiesForMove = async (req, res) => {
  const { moveId } = req.params;

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = `
      SELECT
        mu.id,
        mu.move_id,
        mu.utility_id,
        u.provider_name,
        u.type,
        mu.account_number,
        mu.start_date,
        mu.stop_date,
        mu.status
      FROM move_utilities mu
      JOIN utilities u ON u.id = mu.utility_id
      WHERE mu.move_id = ?
      ORDER BY u.type, u.provider_name
    `;
    db.query(q, [moveId], (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const addUtilityToMove = async (req, res) => {
  const { moveId } = req.params;
  const {
    utility_id,
    account_number = null,
    start_date = null,
    stop_date = null,
    status = "planned"
  } = req.body;

  if (!utility_id) {
    return res.status(400).json({ message: "utility_id is required" });
  }
  if (!ALLOWED_STATUSES.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const exists = await utilityExists(Number(utility_id));
    if (!exists) return res.status(400).json({ message: "Invalid utility_id" });

    const q = `
      INSERT INTO move_utilities
        (move_id, utility_id, account_number, start_date, stop_date, status)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    const params = [
      moveId,
      utility_id,
      account_number,
      start_date,
      stop_date,
      status
    ];

    db.query(q, params, (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ id: result.insertId, message: "Move utility added" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const getMoveUtility = (req, res) => {
  const { id } = req.params;

  const q = `
    SELECT
      mu.id,
      mu.move_id,
      mu.utility_id,
      u.provider_name,
      u.type,
      mu.account_number,
      mu.start_date,
      mu.stop_date,
      mu.status
    FROM move_utilities mu
    JOIN moves m ON m.id = mu.move_id
    JOIN utilities u ON u.id = mu.utility_id
    WHERE mu.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [id, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) {
      return res.status(404).json({ message: "Move utility not found" });
    }
    res.json(rows[0]);
  });
};


export const updateMoveUtility = (req, res) => {
  const { id } = req.params;
  const {
    account_number,
    start_date,
    stop_date,
    status
  } = req.body;

  if (status && !ALLOWED_STATUSES.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  const check = `
    SELECT mu.id
    FROM move_utilities mu
    JOIN moves m ON m.id = mu.move_id
    WHERE mu.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [id, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) {
      return res.status(404).json({ message: "Move utility not found" });
    }

    const fields = [];
    const params = [];

    if (account_number !== undefined) {
      fields.push("account_number = ?");
      params.push(account_number);
    }
    if (start_date !== undefined) {
      fields.push("start_date = ?");
      params.push(start_date);
    }
    if (stop_date !== undefined) {
      fields.push("stop_date = ?");
      params.push(stop_date);
    }
    if (status !== undefined) {
      fields.push("status = ?");
      params.push(status);
    }

    if (!fields.length) {
      return res.status(400).json({ message: "No fields to update" });
    }

    const q2 = `
      UPDATE move_utilities
      SET ${fields.join(", ")}
      WHERE id = ?
      LIMIT 1
    `;
    params.push(id);

    db.query(q2, params, (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: "Move utility updated" });
    });
  });
};


export const deleteMoveUtility = (req, res) => {
  const { id } = req.params;

  const q = `
    DELETE mu
    FROM move_utilities mu
    JOIN moves m ON m.id = mu.move_id
    WHERE mu.id = ? AND m.user_id = ?
  `;
  db.query(q, [id, req.user.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!result.affectedRows) {
      return res.status(404).json({ message: "Move utility not found" });
    }
    res.json({ message: "Move utility deleted" });
  });
};
