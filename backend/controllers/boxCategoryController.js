import { db } from "../db.js";

function userOwnsBox(boxId, userId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_check_user_owns_box(?, ?, @owns)",
      [boxId, userId],
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

function categoryExists(categoryId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_check_category_exists(?, @exists)",
      [categoryId],
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

function listCategoriesForBoxInternal(boxId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_list_categories_for_box(?)",
      [boxId],
      (err, rows) => {
        if (err) return reject(err);
        const data = Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
        resolve(data || []);
      }
    );
  });
}

function attachCategoryToBoxInternal(boxId, categoryId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_attach_category_to_box(?, ?, @created)",
      [boxId, categoryId],
      (err) => {
        if (err) return reject(err);
        db.query("SELECT @created AS created", (err2, rows2) => {
          if (err2) return reject(err2);
          const row = rows2 && rows2[0] ? rows2[0] : {};
          const created =
            row.created === 1 ||
            row.created === true ||
            row.created === "1" ||
            row.created === "true";
          resolve(created);
        });
      }
    );
  });
}

function detachCategoryFromBoxInternal(boxId, categoryId) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_detach_category_from_box(?, ?, @success, @message)",
      [boxId, categoryId],
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

export const listCategoriesForBox = async (req, res) => {
  const { boxId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Box not found" });
    }
    const data = await listCategoriesForBoxInternal(Number(boxId));
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const attachCategoryToBox = async (req, res) => {
  const { boxId, categoryId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Box not found" });
    }

    const exists = await categoryExists(Number(categoryId));
    if (!exists) {
      return res.status(400).json({ message: "Invalid categoryId" });
    }

    const created = await attachCategoryToBoxInternal(
      Number(boxId),
      Number(categoryId)
    );

    if (created) {
      return res
        .status(201)
        .json({ message: "Category attached to box" });
    }
    res.status(200).json({ message: "Already attached" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const detachCategoryFromBox = async (req, res) => {
  const { boxId, categoryId } = req.params;
  try {
    const owns = await userOwnsBox(Number(boxId), req.user.id);
    if (!owns) {
      return res.status(404).json({ message: "Box not found" });
    }

    const result = await detachCategoryFromBoxInternal(
      Number(boxId),
      Number(categoryId)
    );

    if (!result.success) {
      if ((result.message || "").toLowerCase().includes("link not found")) {
        return res.status(404).json({ message: result.message || "Link not found" });
      }
      return res.status(400).json({ message: result.message || "Detach failed" });
    }

    res.json({ message: result.message || "Category detached from box" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
