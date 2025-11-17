import { db } from "../db.js";


export const listAddresses = (req, res) => {
  const q = `
    SELECT *
    FROM addresses
    WHERE user_id = ?
    ORDER BY id DESC
  `;

  db.query(q, [req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
};


export const createAddress = (req, res) => {
  const {
    label,
    line1,
    line2,
    city,
    state,
    postal_code,
    country
  } = req.body;

  if (!label || !line1 || !city || !state || !postal_code || !country) {
    return res
      .status(400)
      .json({ message: "label, line1, city, state, postal_code, country are required" });
  }

  const q = `
    INSERT INTO addresses
      (user_id, label, line1, line2, city, state, postal_code, country)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    q,
    [req.user.id, label, line1, line2 || null, city, state, postal_code, country],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });

      res.status(201).json({
        id: result.insertId,
        message: "Address created"
      });
    }
  );
};
