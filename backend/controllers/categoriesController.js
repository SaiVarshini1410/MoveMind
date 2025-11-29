import { db } from "../db.js";

function callListCategories() {
  return new Promise((resolve, reject) => {
    db.query("CALL sp_list_categories()", (err, rows) => {
      if (err) return reject(err);
      const data = Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
      resolve(data || []);
    });
  });
}

function callCreateCategory(name) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_create_category(?, @category_id, @message)",
      [name],
      (err) => {
        if (err) return reject(err);
        db.query(
          "SELECT @category_id AS category_id, @message AS message",
          (err2, rows2) => {
            if (err2) return reject(err2);
            const row = rows2 && rows2[0] ? rows2[0] : {};
            resolve({
              id: row.category_id,
              message: row.message || ""
            });
          }
        );
      }
    );
  });
}

function callUpdateCategory(id, name) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_update_category(?, ?, @success, @message)",
      [id, name],
      (err) => {
        if (err) return reject(err);
        db.query(
          "SELECT @success AS success, @message AS message",
          (err2, rows2) => {
            if (err2) return reject(err2);
            const row = rows2 && rows2[0] ? rows2[0] : {};
            const success =
              row.success === 1 ||
              row.success === true ||
              row.success === "1" ||
              row.success === "true";
            resolve({
              success,
              message: row.message || ""
            });
          }
        );
      }
    );
  });
}

function callDeleteCategory(id) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_delete_category(?, @success, @message)",
      [id],
      (err) => {
        if (err) return reject(err);
        db.query(
          "SELECT @success AS success, @message AS message",
          (err2, rows2) => {
            if (err2) return reject(err2);
            const row = rows2 && rows2[0] ? rows2[0] : {};
            const success =
              row.success === 1 ||
              row.success === true ||
              row.success === "1" ||
              row.success === "true";
            resolve({
              success,
              message: row.message || ""
            });
          }
        );
      }
    );
  });
}

export const listCategories = async (_req, res) => {
  try {
    const data = await callListCategories();
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const createCategory = async (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ message: "name is required" });

  try {
    const result = await callCreateCategory(name);
    if (!result.id) {
      return res.status(400).json({
        message: result.message || "Category already exists"
      });
    }
    res
      .status(201)
      .json({ id: result.id, message: result.message || "Category created" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const updateCategory = async (req, res) => {
  const { categoryId } = req.params;
  const { name } = req.body;

  if (name === undefined) {
    return res.status(400).json({ message: "No fields to update" });
  }

  try {
    const result = await callUpdateCategory(Number(categoryId), name);
    if (!result.success) {
      if ((result.message || "").toLowerCase().includes("not found")) {
        return res.status(404).json({ message: result.message || "Category not found" });
      }
      if ((result.message || "").toLowerCase().includes("already exists")) {
        return res.status(400).json({ message: result.message || "Category already exists" });
      }
      return res.status(400).json({ message: result.message || "Update failed" });
    }
    res.json({ message: result.message || "Category updated" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const deleteCategory = async (req, res) => {
  const { categoryId } = req.params;

  try {
    const result = await callDeleteCategory(Number(categoryId));
    if (!result.success) {
      if ((result.message || "").toLowerCase().includes("not found")) {
        return res.status(404).json({ message: result.message || "Category not found" });
      }
      return res.status(400).json({ message: result.message || "Delete failed" });
    }
    res.json({ message: result.message || "Category deleted" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
