import { db } from "../db.js";

export const listAddresses = (req, res) => {
  const q = "CALL sp_list_user_addresses(?)";

  db.query(q, [req.user.id], (err, results) => {
    if (err) {
      console.error("sp_list_user_addresses error:", err);
      return res.status(500).json({ error: err.message });
    }
    const rows = results[0] || [];
    return res.json(rows);
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
    return res.status(400).json({
      message:
        "label, line1, city, state, postal_code, country are required"
    });
  }

  const normalizedLine2 = line2 || null;
  const userId = req.user.id;

  const callFind = `
    CALL sp_find_address(?,?,?,?,?,?, @p_address_id)
  `;
  const selectFound = "SELECT @p_address_id AS address_id";

  db.query(
    callFind,
    [line1, normalizedLine2, city, state, postal_code, country],
    (err1) => {
      if (err1) {
        console.error("sp_find_address error:", err1);
        return res.status(500).json({ error: err1.message });
      }

      db.query(selectFound, (err2, rows2) => {
        if (err2) {
          console.error("SELECT @p_address_id error:", err2);
          return res.status(500).json({ error: err2.message });
        }

        const foundId = rows2[0]?.address_id || null;

        if (foundId) {
          return checkUserHasAddress(userId, foundId, label, res);
        }

        const callInsert = `
          CALL sp_insert_address(?,?,?,?,?,?, @p_new_address_id)
        `;
        const selectNew = "SELECT @p_new_address_id AS address_id";

        db.query(
          callInsert,
          [line1, normalizedLine2, city, state, postal_code, country],
          (err3) => {
            if (err3) {
              console.error("sp_insert_address error:", err3);
              return res.status(500).json({ error: err3.message });
            }

            db.query(selectNew, (err4, rows4) => {
              if (err4) {
                console.error("SELECT @p_new_address_id error:", err4);
                return res.status(500).json({ error: err4.message });
              }

              const newId = rows4[0]?.address_id;
              if (!newId) {
                return res
                  .status(500)
                  .json({ error: "Failed to create address." });
              }

              return linkUserAddress(userId, newId, label, res);
            });
          }
        );
      });
    }
  );
};

function checkUserHasAddress(userId, addressId, label, res) {
  const callCheck = `
    CALL sp_check_user_has_address(?,?, @p_exists)
  `;
  const selectExists = "SELECT @p_exists AS exists_flag";

  db.query(callCheck, [userId, addressId], (err1) => {
    if (err1) {
      console.error("sp_check_user_has_address error:", err1);
      return res.status(500).json({ error: err1.message });
    }

    db.query(selectExists, (err2, rows2) => {
      if (err2) {
        console.error("SELECT @p_exists error:", err2);
        return res.status(500).json({ error: err2.message });
      }

      const exists = rows2[0]?.exists_flag === 1;

      if (exists) {
        return res
          .status(400)
          .json({ message: "You already saved this address." });
      }

      return linkUserAddress(userId, addressId, label, res);
    });
  });
}

function linkUserAddress(userId, addressId, label, res) {
  const callLink = "CALL sp_link_user_address(?,?,?)";

  db.query(callLink, [userId, addressId, label], (err) => {
    if (err) {
      console.error("sp_link_user_address error:", err);
      if (err.code === "ER_DUP_ENTRY") {
        return res
          .status(400)
          .json({ message: "You already saved this address." });
      }
      return res.status(500).json({ error: err.message });
    }

    return res.status(201).json({
      id: addressId,
      message: "Address created"
    });
  });
}
