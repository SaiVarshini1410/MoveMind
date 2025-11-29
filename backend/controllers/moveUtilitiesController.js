import { db } from "../db.js";

const ALLOWED_STATUSES = new Set([
  "planned",
  "requested",
  "confirmed",
  "active",
  "cancelled"
]);

function checkUserOwnsMove(moveId, userId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_check_user_owns_move(?, ?, @owns)",
      [moveId, userId],
      (err) => {
        if (err) return reject(err);
        db.query("SELECT @owns AS owns", (err2, rows2) => {
          if (err2) return reject(err2);
          const row = rows2 && rows2[0] ? rows2[0] : {};
          const owns =
            row.owns === 1 ||
            row.owns === true ||
            row.owns === "1" ||
            row.owns === "true";
          resolve(owns);
        });
      }
    );
  });
}

function checkUtilityExists(utilityId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_check_utility_exists(?, @exists)",
      [utilityId],
      (err) => {
        if (err) return reject(err);
        db.query("SELECT @exists AS existsFlag", (err2, rows2) => {
          if (err2) return reject(err2);
          const row = rows2 && rows2[0] ? rows2[0] : {};
          const exists =
            row.existsFlag === 1 ||
            row.existsFlag === true ||
            row.existsFlag === "1" ||
            row.existsFlag === "true";
          resolve(exists);
        });
      }
    );
  });
}

function checkMoveUtilityExists(moveId, utilityId, userId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_check_move_utility_exists(?, ?, ?, @exists)",
      [moveId, utilityId, userId],
      (err) => {
        if (err) return reject(err);
        db.query("SELECT @exists AS existsFlag", (err2, rows2) => {
          if (err2) return reject(err2);
          const row = rows2 && rows2[0] ? rows2[0] : {};
          const exists =
            row.existsFlag === 1 ||
            row.existsFlag === true ||
            row.existsFlag === "1" ||
            row.existsFlag === "true";
          resolve(exists);
        });
      }
    );
  });
}

export const listUtilitiesForMove = async (req, res) => {
  const { moveId } = req.params;

  try {
    const owns = await checkUserOwnsMove(Number(moveId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Move not found" });
    }

    db.query(
      "CALL sp_list_utilities_for_move(?, ?)",
      [moveId, req.user.id],
      (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        const data = Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
        res.json(data || []);
      }
    );
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
    const owns = await checkUserOwnsMove(Number(moveId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Move not found" });
    }

    const exists = await checkUtilityExists(Number(utility_id));
    if (!exists) {
      return res.status(400).json({ message: "Invalid utility_id" });
    }

    const params = [
      Number(moveId),
      Number(utility_id),
      account_number || null,
      start_date || null,
      stop_date || null,
      status,
      null,
      null
    ];

    db.query(
      "CALL sp_add_utility_to_move(?, ?, ?, ?, ?, ?, @success, @message)",
      params.slice(0, 6),
      (err) => {
        if (err) {
          if (err.code === "ER_DUP_ENTRY") {
            return res
              .status(400)
              .json({ message: "Utility already attached to this move" });
          }
          return res.status(500).json({ error: err.message });
        }

        db.query("SELECT @success AS success, @message AS message", (err2, rows2) => {
          if (err2) return res.status(500).json({ error: err2.message });

          const row = rows2 && rows2[0] ? rows2[0] : {};
          const success =
            row.success === 1 ||
            row.success === true ||
            row.success === "1" ||
            row.success === "true";
          const message = row.message || "Move utility added";

          if (!success) {
            return res.status(400).json({ message });
          }

          res.status(201).json({ message });
        });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateMoveUtility = async (req, res) => {
  const { moveId, utilityId } = req.params;
  const { account_number, start_date, stop_date, status } = req.body;

  if (status && !ALLOWED_STATUSES.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  if (
    account_number === undefined &&
    start_date === undefined &&
    stop_date === undefined &&
    status === undefined
  ) {
    return res.status(400).json({ message: "No fields to update" });
  }

  try {
    const exists = await checkMoveUtilityExists(
      Number(moveId),
      Number(utilityId),
      req.user.id
    );
    if (!exists) {
      return res.status(404).json({ message: "Move utility not found" });
    }

    const pAccount = account_number === undefined ? null : account_number;
    const pStart = start_date === undefined ? null : start_date;
    const pStop = stop_date === undefined ? null : stop_date;
    const pStatus = status === undefined ? null : status;

    db.query(
      "CALL sp_update_move_utility(?, ?, ?, ?, ?, ?)",
      [Number(moveId), Number(utilityId), pAccount, pStart, pStop, pStatus],
      (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: "Move utility updated" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const deleteMoveUtility = (req, res) => {
  const { moveId, utilityId } = req.params;

  db.query(
    "CALL sp_delete_move_utility(?, ?, ?, @success, @message)",
    [Number(moveId), Number(utilityId), req.user.id],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });

      db.query("SELECT @success AS success, @message AS message", (err2, rows2) => {
        if (err2) return res.status(500).json({ error: err2.message });

        const row = rows2 && rows2[0] ? rows2[0] : {};
        const success =
          row.success === 1 ||
          row.success === true ||
          row.success === "1" ||
          row.success === "true";
        const message = row.message || "Move utility deleted";

        if (!success) {
          return res.status(404).json({ message });
        }

        res.json({ message });
      });
    }
  );
};
