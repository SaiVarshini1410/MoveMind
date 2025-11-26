import { db } from "../db.js";


const userOwnsBox = (boxId, userId) =>
  new Promise((resolve, reject) => {
    const q = `
      SELECT b.id
      FROM boxes b
      JOIN rooms r
        ON r.move_id = b.move_id
       AND r.name    = b.room_name
      JOIN moves m ON m.id = r.move_id
      WHERE b.id = ? AND m.user_id = ?
      LIMIT 1
    `;
    db.query(q, [boxId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });



const categoryExists = (categoryId) =>
  new Promise((resolve, reject) => {
    db.query("SELECT id FROM categories WHERE id = ? LIMIT 1", [categoryId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });


export const listCategoriesForBox = async (req, res) => {
  const { boxId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const q = `
      SELECT c.id, c.name
      FROM box_categories bc
      JOIN categories c ON c.id = bc.category_id
      WHERE bc.box_id = ?
      ORDER BY c.name ASC
    `;
    db.query(q, [boxId], (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const attachCategoryToBox = async (req, res) => {
  const { boxId, categoryId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    const catOk = await categoryExists(Number(categoryId));
    if (!catOk) return res.status(400).json({ message: "Invalid categoryId" });

    db.query(
      "INSERT IGNORE INTO box_categories (box_id, category_id) VALUES (?, ?)",
      [boxId, categoryId],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        const created = result.affectedRows > 0;
        res.status(created ? 201 : 200).json({
          message: created ? "Category attached to box" : "Already attached"
        });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const detachCategoryFromBox = async (req, res) => {
  const { boxId, categoryId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Box not found" });

    db.query(
      "DELETE FROM box_categories WHERE box_id = ? AND category_id = ?",
      [boxId, categoryId],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!result.affectedRows) return res.status(404).json({ message: "Link not found" });
        res.json({ message: "Category detached from box" });
      }
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
