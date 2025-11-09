import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { db } from "../db.js";

dotenv.config();

const makeToken = (user) => {
  if (!process.env.JWT_SECRET) {
    console.error("JWT_SECRET is missing in .env");
    throw new Error("JWT secret missing");
  }
  return jwt.sign(
    { id: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES || "1h" }
  );
};

export const registerUser = (req, res) => {
  let { first_name, last_name, email, password } = req.body;

  if (!first_name || !last_name || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  first_name = String(first_name).trim();
  last_name = String(last_name).trim();
  email = String(email).trim().toLowerCase();

  const q1 = "SELECT id FROM users WHERE email = ?";
  db.query(q1, [email], async (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (rows.length) return res.status(400).json({ message: "User already exists" });

    const hashed = await bcrypt.hash(password, 10);

    const q2 = `
      INSERT INTO users (first_name, last_name, email, password)
      VALUES (?, ?, ?, ?)
    `;
    db.query(q2, [first_name, last_name, email, hashed], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      return res.status(201).json({ message: "User registered successfully" });
    });
  });
};

export const loginUser = (req, res) => {
  let { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ message: "Email and password are required" });

  email = String(email).trim().toLowerCase();

  const q = "SELECT id, first_name, last_name, email, password FROM users WHERE email = ?";
  db.query(q, [email], async (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) return res.status(404).json({ message: "User not found" });

    const user = rows[0];
    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(400).json({ message: "Invalid credentials" });

    try {
      const token = makeToken(user);
      return res.json({
        message: "Login successful",
        token,
        user: {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
        },
      });
    } catch (e) {
      console.error("JWT error:", e.message);
      return res.status(500).json({ message: "Auth server misconfigured" });
    }
  });
};

export const getMe = (req, res) => {
  res.json({ user: req.user });
};
