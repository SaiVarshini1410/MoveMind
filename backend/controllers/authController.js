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

function callRegisterUser(firstName, lastName, email, hashedPassword) {
  return new Promise((resolve, reject) => {
    db.query(
      "CALL sp_register_user(?, ?, ?, ?, @user_id, @message)",
      [firstName, lastName, email, hashedPassword],
      (err) => {
        if (err) return reject(err);
        db.query(
          "SELECT @user_id AS user_id, @message AS message",
          (err2, rows2) => {
            if (err2) return reject(err2);
            const row = rows2 && rows2[0] ? rows2[0] : {};
            resolve({
              userId: row.user_id,
              message: row.message || ""
            });
          }
        );
      }
    );
  });
}

function callGetUserByEmail(email) {
  return new Promise((resolve, reject) => {
    db.query("CALL sp_get_user_by_email(?)", [email], (err, rows) => {
      if (err) return reject(err);
      const data = Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0] : [];
      resolve(data[0] || null);
    });
  });
}

export const registerUser = async (req, res) => {
  let { first_name, last_name, email, password } = req.body;

  if (!first_name || !last_name || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  first_name = String(first_name).trim();
  last_name = String(last_name).trim();
  email = String(email).trim().toLowerCase();

  try {
    const hashed = await bcrypt.hash(password, 10);
    const result = await callRegisterUser(first_name, last_name, email, hashed);

    if (!result.userId) {
      return res.status(400).json({
        message: result.message || "User already exists"
      });
    }

    return res
      .status(201)
      .json({ message: result.message || "User registered successfully" });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
};

export const loginUser = async (req, res) => {
  let { email, password } = req.body;

  if (!email || !password) {
    return res
      .status(400)
      .json({ message: "Email and password are required" });
  }

  email = String(email).trim().toLowerCase();

  try {
    const user = await callGetUserByEmail(email);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const token = makeToken(user);
    return res.json({
      message: "Login successful",
      token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email
      }
    });
  } catch (e) {
    console.error("Auth error:", e.message);
    return res.status(500).json({ message: "Auth server error" });
  }
};

export const getMe = (req, res) => {
  res.json({ user: req.user });
};
