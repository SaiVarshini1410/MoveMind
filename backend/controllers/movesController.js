import { db } from "../db.js";

const ALLOWED_STATUS = new Set([
  "planned",
  "packing",
  "in_transit",
  "unpacking",
  "done"
]);

export const listMoves = (req, res) => {
  const q = "CALL sp_list_moves(?)";
  db.query(q, [req.user.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    const rows = results && results[0] ? results[0] : [];
    res.json(rows);
  });
};

export const getMove = (req, res) => {
  const { id } = req.params;
  const q = "CALL sp_get_move(?, ?)";
  db.query(q, [id, req.user.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    const rows = results && results[0] ? results[0] : [];
    if (!rows.length) return res.status(404).json({ message: "Move not found" });
    res.json(rows[0]);
  });
};

export const createMove = (req, res) => {
  const {
    title,
    move_date,
    status = "planned",
    from_address_id,
    to_address_id
  } = req.body;

  if (!title || !move_date || !from_address_id || !to_address_id) {
    return res.status(400).json({
      message: "title, move_date, from_address_id, to_address_id are required"
    });
  }

  if (!ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  const call = "CALL sp_create_move(?,?,?,?,?,?,@p_move_id,@p_message)";
  db.query(
    call,
    [
      req.user.id,
      title,
      move_date,
      status,
      from_address_id,
      to_address_id
    ],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });

      const outQuery = "SELECT @p_move_id AS move_id, @p_message AS message";
      db.query(outQuery, (err2, rows2) => {
        if (err2) return res.status(500).json({ error: err2.message });
        const row = rows2 && rows2[0] ? rows2[0] : {};
        if (!row.move_id) {
          const msg = row.message || "Failed to create move";
          return res.status(400).json({ message: msg });
        }
        res
          .status(201)
          .json({ id: row.move_id, message: row.message || "Move created" });
      });
    }
  );
};

export const updateMove = (req, res) => {
  const { id } = req.params;
  const { title, move_date, status, from_address_id, to_address_id } = req.body;

  if (status !== undefined && !ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  if (move_date !== undefined && !move_date) {
    return res
      .status(400)
      .json({ message: "move_date cannot be empty or null" });
  }

  const titleParam = title !== undefined ? title : null;
  const moveDateParam = move_date !== undefined ? move_date : null;
  const statusParam = status !== undefined ? status : null;
  const fromAddressParam =
    from_address_id !== undefined ? from_address_id : null;
  const toAddressParam = to_address_id !== undefined ? to_address_id : null;

  const call =
    "CALL sp_update_move(?,?,?,?,?,?,?,@p_success,@p_message)";
  db.query(
    call,
    [
      id,
      req.user.id,
      titleParam,
      moveDateParam,
      statusParam,
      fromAddressParam,
      toAddressParam
    ],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });

      const outQuery =
        "SELECT @p_success AS success, @p_message AS message";
      db.query(outQuery, (err2, rows2) => {
        if (err2) return res.status(500).json({ error: err2.message });
        const row = rows2 && rows2[0] ? rows2[0] : {};
        const success = row.success === 1 || row.success === true;
        const msg = row.message || "";

        if (!success) {
          if (msg === "Move not found") {
            return res.status(404).json({ message: msg });
          }
          if (
            msg === "Invalid from_address_id" ||
            msg === "Invalid to_address_id"
          ) {
            return res.status(400).json({ message: msg });
          }
          return res.status(400).json({ message: msg || "Failed to update move" });
        }

        res.json({ message: msg || "Move updated" });
      });
    }
  );
};

export const deleteMove = (req, res) => {
  const { id } = req.params;

  const call = "CALL sp_delete_move(?,?,@p_success,@p_message)";
  db.query(call, [id, req.user.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });

    const outQuery =
      "SELECT @p_success AS success, @p_message AS message";
    db.query(outQuery, (err2, rows2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      const row = rows2 && rows2[0] ? rows2[0] : {};
      const success = row.success === 1 || row.success === true;
      const msg = row.message || "";

      if (!success) {
        if (msg === "Move not found") {
          return res.status(404).json({ message: msg });
        }
        return res.status(400).json({ message: msg || "Failed to delete move" });
      }

      res.json({ message: msg || "Move deleted" });
    });
  });
};
