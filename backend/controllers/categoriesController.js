import { db } from "../db.js";


export const listCategories = (_req, res) => {
  db.query("SELECT id, name FROM categories ORDER BY name ASC", (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
};


export const createCategory = (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ message: "name is required" });

  db.query(
    "INSERT INTO categories (name) VALUES (?)",
    [name],
    (err, result) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).json({ message: "Category already exists" });
        }
        return res.status(500).json({ error: err.message });
      }
      res.status(201).json({ id: result.insertId, message: "Category created" });
    }
  );
};


export const updateCategory = (req, res) => {
  const { categoryId } = req.params;
  const { name } = req.body;
  if (name === undefined) return res.status(400).json({ message: "No fields to update" });

  db.query(
    "UPDATE categories SET name = ? WHERE id = ?",
    [name, categoryId],
    (err, result) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).json({ message: "Category already exists" });
        }
        return res.status(500).json({ error: err.message });
      }
      if (!result.affectedRows) return res.status(404).json({ message: "Category not found" });
      res.json({ message: "Category updated" });
    }
  );
};


export const deleteCategory = (req, res) => {
  const { categoryId } = req.params;

  db.query("DELETE FROM categories WHERE id = ? LIMIT 1", [categoryId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!result.affectedRows) return res.status(404).json({ message: "Category not found" });
    res.json({ message: "Category deleted" });
  });
};
