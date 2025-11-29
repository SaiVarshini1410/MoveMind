import { db } from "../db.js";

const userOwnsBox = (boxId, userId) =>
  new Promise((resolve, reject) => {
    db.query("SET @owns := NULL", (err) => {
      if (err) return reject(err);

      db.query(
        "CALL sp_check_user_owns_box(?, ?, @owns)",
        [boxId, userId],
        (err2) => {
          if (err2) return reject(err2);

          db.query("SELECT @owns AS owns", (err3, rows) => {
            if (err3) return reject(err3);
            const owns = rows && rows[0] ? Boolean(rows[0].owns) : false;
            resolve(owns);
          });
        }
      );
    });
  });

const userOwnsItem = (itemId, userId) =>
  new Promise((resolve, reject) => {
    db.query("SET @owns := NULL", (err) => {
      if (err) return reject(err);

      db.query(
        "CALL sp_check_user_owns_item(?, ?, @owns)",
        [itemId, userId],
        (err2) => {
          if (err2) return reject(err2);

          db.query("SELECT @owns AS owns", (err3, rows) => {
            if (err3) return reject(err3);
            const owns = rows && rows[0] ? Boolean(rows[0].owns) : false;
            resolve(owns);
          });
        }
      );
    });
  });

export const listItemsByBox = async (req, res) => {
  const { boxId } = req.params;

  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Box not found" });
    }

    db.query("CALL sp_list_items_by_box(?)", [boxId], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });

      const rows = Array.isArray(results) && Array.isArray(results[0])
        ? results[0]
        : [];

      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const createItem = async (req, res) => {
  const { boxId } = req.params;
  const { name, quantity = 1, value = null } = req.body;

  if (!name) {
    return res.status(400).json({ message: "name is required" });
  }

  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Box not found" });
    }

    db.query(
      "CALL sp_create_item(?, ?, ?, ?)",
      [boxId, name, quantity, value],
      (err, results) => {
        if (err) return res.status(500).json({ error: err.message });

        const newId =
          Array.isArray(results) &&
          Array.isArray(results[0]) &&
          results[0][0] &&
          results[0][0].id
            ? results[0][0].id
            : null;

        res
          .status(201)
          .json({ id: newId, message: "Item created" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const getItem = async (req, res) => {
  const { itemId } = req.params;

  try {
    const owns = await userOwnsItem(Number(itemId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Item not found" });
    }

    db.query("CALL sp_get_item(?)", [itemId], (err, results) => {
      if (err) return res.status(500).json({ error: err.message });

      const rows = Array.isArray(results) && Array.isArray(results[0])
        ? results[0]
        : [];

      if (!rows.length) {
        return res.status(404).json({ message: "Item not found" });
      }

      res.json(rows[0]);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateItem = async (req, res) => {
  const { itemId } = req.params;
  const { name, quantity, value } = req.body;

  if (
    name === undefined &&
    quantity === undefined &&
    value === undefined
  ) {
    return res.status(400).json({ message: "No fields to update" });
  }

  try {
    const owns = await userOwnsItem(Number(itemId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Item not found" });
    }

    const pName = name === undefined ? null : name;
    const pQuantity = quantity === undefined ? null : quantity;
    const pValue = value === undefined ? null : value;

    db.query(
      "CALL sp_update_item(?, ?, ?, ?)",
      [itemId, pName, pQuantity, pValue],
      (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: "Item updated" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const deleteItem = async (req, res) => {
  const { itemId } = req.params;

  try {
    const owns = await userOwnsItem(Number(itemId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Item not found" });
    }

    db.query("CALL sp_delete_item(?)", [itemId], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Item deleted" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
