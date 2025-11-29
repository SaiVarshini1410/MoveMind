import { db } from "../db.js";

const ALLOWED_STATUS = new Set([
  "empty",
  "packed",
  "loaded",
  "delivered",
  "unpacked"
]);

const checkUserOwnsRoom = (moveId, roomName, userId) =>
  new Promise((resolve, reject) => {
    const callSql = "CALL sp_check_user_owns_room(?, ?, ?, @owns)";
    db.query(callSql, [moveId, roomName, userId], (err) => {
      if (err) return reject(err);
      db.query("SELECT @owns AS owns", (err2, rows2) => {
        if (err2) return reject(err2);
        const owns = Boolean(rows2?.[0]?.owns);
        resolve(owns);
      });
    });
  });

const checkUserOwnsBox = (boxId, userId) =>
  new Promise((resolve, reject) => {
    const callSql = "CALL sp_check_user_owns_box(?, ?, @owns)";
    db.query(callSql, [boxId, userId], (err) => {
      if (err) return reject(err);
      db.query("SELECT @owns AS owns", (err2, rows2) => {
        if (err2) return reject(err2);
        const owns = Boolean(rows2?.[0]?.owns);
        resolve(owns);
      });
    });
  });

export const listBoxesByRoom = async (req, res) => {
  const { moveId, roomName } = req.params;
  const { status } = req.query;

  try {
    const ownsRoom = await checkUserOwnsRoom(Number(moveId), roomName, req.user.id);
    if (!ownsRoom) return res.status(404).json({ message: "Room not found" });

    if (status && !ALLOWED_STATUS.has(status)) {
      return res.status(400).json({ message: "Invalid status" });
    }

    const sql = "CALL sp_list_boxes_by_room(?, ?, ?)";
    const statusParam = status || null;

    db.query(sql, [moveId, roomName, statusParam], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      const rows = (results && results[0]) || [];
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
    const ownsRoom = await checkUserOwnsRoom(Number(moveId), roomName, req.user.id);
    if (!ownsRoom) return res.status(404).json({ message: "Room not found" });

    const sql = "CALL sp_create_box(?, ?, ?, ?, ?, ?)";
    const params = [
      moveId,
      roomName,
      label_code,
      fragile ? 1 : 0,
      weight,
      status
    ];

    db.query(sql, params, (err, results) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).json({ message: "label_code must be unique" });
        }
        return res.status(500).json({ error: err.message });
      }

      const rows = (results && results[0]) || [];
      const row = rows[0] || {};
      const newId = row.id;

      res.status(201).json({
        id: newId,
        message: "Box created"
      });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const getBox = async (req, res) => {
  const { boxId } = req.params;

  try {
    const owns = await checkUserOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const sql = "CALL sp_get_box(?)";
    db.query(sql, [boxId], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      const rows = (results && results[0]) || [];
      if (!rows.length) {
        return res.status(404).json({ message: "Box not found" });
      }
      res.json(rows[0]);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateBox = async (req, res) => {
  const { boxId } = req.params;
  const { label_code, fragile, weight, status } = req.body;

  if (status && !ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  const hasAnyField =
    label_code !== undefined ||
    fragile !== undefined ||
    weight !== undefined ||
    status !== undefined;

  if (!hasAnyField) {
    return res.status(400).json({ message: "No fields to update" });
  }

  try {
    const owns = await checkUserOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const sql = "CALL sp_update_box(?, ?, ?, ?, ?)";
    const params = [
      boxId,
      label_code !== undefined ? label_code : null,
      fragile !== undefined ? (fragile ? 1 : 0) : null,
      weight !== undefined ? weight : null,
      status !== undefined ? status : null
    ];

    db.query(sql, params, (err) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).json({ message: "label_code must be unique" });
        }
        return res.status(500).json({ error: err.message });
      }
      res.json({ message: "Box updated" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const deleteBox = async (req, res) => {
  const { boxId } = req.params;

  try {
    const owns = await checkUserOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const sql = "CALL sp_delete_box(?)";
    db.query(sql, [boxId], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Box deleted" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const scanByLabel = (req, res) => {
  const { labelCode } = req.params;
  const sql = "CALL sp_scan_box_by_label(?, ?)";

  db.query(sql, [labelCode, req.user.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    const rows = (results && results[0]) || [];
    if (!rows.length) return res.status(404).json({ message: "Box not found" });
    res.json(rows[0]);
  });
};
