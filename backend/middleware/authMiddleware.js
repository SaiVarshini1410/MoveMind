import jwt from "jsonwebtoken";
import { db } from "../db.js";

export const requireAuth = (req, res, next) => {
  const header = req.headers.authorization || "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : null;
  if (!token) return res.status(401).json({ message: "No token provided" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const q = "SELECT id, first_name, last_name, email FROM users WHERE id = ?";
    db.query(q, [decoded.id], (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!rows.length) return res.status(401).json({ message: "Invalid token user" });
      req.user = rows[0];
      next();
    });
  } catch {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};
