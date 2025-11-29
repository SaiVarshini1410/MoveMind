import { db } from "../db.js";

const ALLOWED_TYPES = new Set([
  "electricity",
  "gas",
  "water",
  "internet",
  "trash",
  "other"
]);

export const listUtilities = (_req, res) => {
  const sql = "CALL sp_list_utilities()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    const rows = results && results[0] ? results[0] : [];
    res.json(rows);
  });
};

export const createUtility = (req, res) => {
  const { provider_name, type } = req.body;

  if (!provider_name || !type) {
    return res
      .status(400)
      .json({ message: "provider_name and type are required" });
  }
  if (!ALLOWED_TYPES.has(type)) {
    return res.status(400).json({ message: "Invalid type" });
  }

  const sql =
    "CALL sp_create_utility(?, ?, @p_utility_id, @p_message); SELECT @p_utility_id AS utility_id, @p_message AS message;";
  db.query(sql, [provider_name, type], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    const outRow =
      results && results[1] && results[1][0] ? results[1][0] : null;

    res.status(201).json({
      id: outRow ? outRow.utility_id : null,
      message: outRow ? outRow.message : "Utility created"
    });
  });
};

export const updateUtility = (req, res) => {
  const { utilityId } = req.params;
  const { provider_name, type } = req.body;

  if (type !== undefined && !ALLOWED_TYPES.has(type)) {
    return res.status(400).json({ message: "Invalid type" });
  }

  if (provider_name === undefined && type === undefined) {
    return res.status(400).json({ message: "No fields to update" });
  }

  const sql =
    "CALL sp_update_utility(?, ?, ?, @p_success, @p_message); SELECT @p_success AS success, @p_message AS message;";
  db.query(
    sql,
    [utilityId, provider_name ?? null, type ?? null],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });

      const outRow =
        results && results[1] && results[1][0] ? results[1][0] : null;

      if (!outRow || Number(outRow.success) === 0) {
        return res
          .status(404)
          .json({ message: outRow ? outRow.message : "Utility not found" });
      }

      res.json({ message: outRow.message || "Utility updated" });
    }
  );
};

export const deleteUtility = (req, res) => {
  const { utilityId } = req.params;

  const sql =
    "CALL sp_delete_utility(?, @p_success, @p_message); SELECT @p_success AS success, @p_message AS message;";
  db.query(sql, [utilityId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    const outRow =
      results && results[1] && results[1][0] ? results[1][0] : null;

    if (!outRow || Number(outRow.success) === 0) {
      return res
        .status(404)
        .json({ message: outRow ? outRow.message : "Utility not found" });
    }

    res.json({ message: outRow.message || "Utility deleted" });
  });
};