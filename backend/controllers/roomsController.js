// backend/controllers/roomsController.js
import { db } from "../db.js";

const checkUserOwnsMove = (moveId, userId) =>
  new Promise((resolve, reject) => {
    const callSql = "CALL sp_check_user_owns_move(?, ?, @owns)";
    db.query(callSql, [moveId, userId], (err) => {
      if (err) return reject(err);

      const selectSql = "SELECT @owns AS owns";
      db.query(selectSql, (err2, rows) => {
        if (err2) return reject(err2);
        try {
          const ownsVal = rows?.[0]?.owns;
          const owns =
            ownsVal === 1 ||
            ownsVal === "1" ||
            ownsVal === true ||
            ownsVal === "true";
          resolve(!!owns);
        } catch (e) {
          reject(e);
        }
      });
    });
  });

const checkRoomAndOwnership = (moveId, roomName, userId) =>
  new Promise((resolve, reject) => {
    const callSql = "CALL sp_check_room_and_ownership(?, ?, ?, @exists)";
    db.query(callSql, [moveId, roomName, userId], (err) => {
      if (err) return reject(err);

      const selectSql = "SELECT @exists AS exists_flag";
      db.query(selectSql, (err2, rows) => {
        if (err2) return reject(err2);
        try {
          const val = rows?.[0]?.exists_flag;
          const exists =
            val === 1 || val === "1" || val === true || val === "true";
          resolve(!!exists);
        } catch (e) {
          reject(e);
        }
      });
    });
  });

export const listRooms = async (req, res) => {
  const { moveId } = req.params;
  try {
    const owns = await checkUserOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const sql = "CALL sp_list_rooms(?)";
    db.query(sql, [moveId], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      const rows = results?.[0] || [];
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
    const owns = await checkUserOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const sql = "CALL sp_create_room(?, ?, ?)";
    db.query(sql, [moveId, name, floor || null], (err) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res
            .status(400)
            .json({ message: "Room name must be unique per move" });
        }
        return res.status(500).json({ error: err.message });
      }
      res.status(201).json({ message: "Room created" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateRoom = async (req, res) => {
  const { moveId, roomName } = req.params;
  const { name, floor } = req.body;

  try {
    const exists = await checkRoomAndOwnership(
      Number(moveId),
      roomName,
      req.user.id
    );
    if (!exists) return res.status(404).json({ message: "Room not found" });

    const hasName = name !== undefined;
    const hasFloor = floor !== undefined;

    if (!hasName && !hasFloor) {
      return res.status(400).json({ message: "No fields to update" });
    }

    let sql;
    let params;

    if (hasName && hasFloor) {
      sql = "CALL sp_update_room_both(?, ?, ?, ?)";
      params = [moveId, roomName, name, floor || null];
    } else if (hasName) {
      sql = "CALL sp_update_room_name(?, ?, ?)";
      params = [moveId, roomName, name];
    } else {
      sql = "CALL sp_update_room_floor(?, ?, ?)";
      params = [moveId, roomName, floor || null];
    }

    db.query(sql, params, (err) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res
            .status(400)
            .json({ message: "Room name must be unique per move" });
        }
        return res.status(500).json({ error: err.message });
      }
      res.json({ message: "Room updated" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const deleteRoom = async (req, res) => {
  const { moveId, roomName } = req.params;

  try {
    const exists = await checkRoomAndOwnership(
      Number(moveId),
      roomName,
      req.user.id
    );
    if (!exists) return res.status(404).json({ message: "Room not found" });

    const sql = "CALL sp_delete_room(?, ?)";
    db.query(sql, [moveId, roomName], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Room deleted" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
