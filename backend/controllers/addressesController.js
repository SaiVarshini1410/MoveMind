import { db } from "../db.js";

export const listAddresses = (req, res) => {
  const q = `
    SELECT
      a.id,
      ua.label,
      a.line1,
      a.line2,
      a.city,
      a.state,
      a.postal_code,
      a.country
    FROM user_addresses ua
    JOIN addresses a ON a.id = ua.address_id
    WHERE ua.user_id = ?
    ORDER BY a.id DESC
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
      .json({
        message:
          "label, line1, city, state, postal_code, country are required"
      });
  }

  const normalizedLine2 = line2 || null;

  const findAddressQuery = `
    SELECT id
    FROM addresses
    WHERE line1 = ?
      AND city = ?
      AND state = ?
      AND postal_code = ?
      AND country = ?
      AND (
        (line2 IS NULL AND ? IS NULL) OR
        (line2 = ?)
      )
    LIMIT 1
  `;

  db.query(
    findAddressQuery,
    [line1, city, state, postal_code, country, normalizedLine2, normalizedLine2],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });

      const handleUserAddressLink = (addressId) => {
        const insertUserAddressQuery = `
          INSERT INTO user_addresses (user_id, address_id, label)
          VALUES (?, ?, ?)
        `;

        db.query(
          insertUserAddressQuery,
          [req.user.id, addressId, label],
          (linkErr) => {
            if (linkErr) {
              if (linkErr.code === "ER_DUP_ENTRY") {
                return res
                  .status(400)
                  .json({ message: "You already saved this address." });
              }
              return res.status(500).json({ error: linkErr.message });
            }

            res.status(201).json({
              id: addressId,
              message: "Address created"
            });
          }
        );
      };

      if (rows.length > 0) {
        const addressId = rows[0].id;
        return handleUserAddressLink(addressId);
      }

      const insertAddressQuery = `
        INSERT INTO addresses
          (line1, line2, city, state, postal_code, country)
        VALUES (?, ?, ?, ?, ?, ?)
      `;

      db.query(
        insertAddressQuery,
        [line1, normalizedLine2, city, state, postal_code, country],
        (insertErr, insertResult) => {
          if (insertErr) {
            if (insertErr.code === "ER_DUP_ENTRY") {
              return res
                .status(400)
                .json({ message: "This address already exists." });
            }
            return res.status(500).json({ error: insertErr.message });
          }

          const newAddressId = insertResult.insertId;
          handleUserAddressLink(newAddressId);
        }
      );
    }
  );
};
