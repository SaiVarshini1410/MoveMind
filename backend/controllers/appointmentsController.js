import { db } from "../db.js";

const ALLOWED_STATUS = new Set([
  "scheduled",
  "completed",
  "cancelled"
]);


const userOwnsMove = (moveId, userId) =>
  new Promise((resolve, reject) => {
    const q = "SELECT id FROM moves WHERE id = ? AND user_id = ? LIMIT 1";
    db.query(q, [moveId, userId], (err, rows) => {
      if (err) return reject(err);
      resolve(rows.length === 1);
    });
  });


export const listAppointmentsByMove = async (req, res) => {
  const { moveId } = req.params;
  const { status, date } = req.query;

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const where = ["a.move_id = ?"];
    const params = [moveId];

    if (status) {
      if (!ALLOWED_STATUS.has(status)) {
        return res.status(400).json({ message: "Invalid status" });
      }
      where.push("a.status = ?");
      params.push(status);
    }

    if (date) {
      where.push("a.apt_date = ?");
      params.push(date);
    }

    const q = `
      SELECT
        a.id,
        a.move_id,
        a.title,
        a.description,
        a.person,
        a.apt_date,
        a.apt_time,
        a.contact_person,
        a.contact_phone,
        a.status
      FROM appointments a
      WHERE ${where.join(" AND ")}
      ORDER BY a.apt_date ASC, a.apt_time ASC, a.id DESC
    `;
    db.query(q, params, (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};


export const createAppointment = async (req, res) => {
  const { moveId } = req.params;
  const {
    title,
    description = null,
    person = null,
    apt_date,
    apt_time,
    contact_person = null,
    contact_phone = null,
    status = "scheduled"
  } = req.body;


  if (!title || !apt_date || !apt_time) {
    return res.status(400).json({
      message: "title, apt_date, apt_time are required"
    });
  }

  if (!ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    const owns = await userOwnsMove(Number(moveId), req.user.id);
    if (!owns) return res.status(404).json({ message: "Move not found" });

    const q = `
      INSERT INTO appointments
        (move_id, title, description, person,
         apt_date, apt_time, contact_person, contact_phone, status)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const params = [
      moveId,
      title,
      description,
      person,
      apt_date,
      apt_time,
      contact_person,
      contact_phone,
      status
    ];

    db.query(q, params, (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res
        .status(201)
        .json({ id: result.insertId, message: "Appointment created" });
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};



export const getAppointment = (req, res) => {
  const { appointmentId } = req.params;

  const q = `
    SELECT
      a.id,
      a.move_id,
      a.title,
      a.description,
      a.person,
      a.apt_date,
      a.apt_time,
      a.contact_person,
      a.contact_phone,
      a.status
    FROM appointments a
    JOIN moves m ON m.id = a.move_id
    WHERE a.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [appointmentId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) {
      return res.status(404).json({ message: "Appointment not found" });
    }
    res.json(rows[0]);
  });
};


export const updateAppointment = (req, res) => {
  const { appointmentId } = req.params;
  const {
    title,
    description,
    person,
    apt_date,
    apt_time,
    contact_person,
    contact_phone,
    status
  } = req.body;

  if (status && !ALLOWED_STATUS.has(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }


  const check = `
    SELECT a.id
    FROM appointments a
    JOIN moves m ON m.id = a.move_id
    WHERE a.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(check, [appointmentId, req.user.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!rows.length) {
      return res.status(404).json({ message: "Appointment not found" });
    }

    const fields = [];
    const params = [];

    if (title !== undefined)          { fields.push("title = ?");          params.push(title); }
    if (description !== undefined)    { fields.push("description = ?");    params.push(description); }
    if (person !== undefined)         { fields.push("person = ?");         params.push(person); }
    if (apt_date !== undefined)       { fields.push("apt_date = ?");       params.push(apt_date); }
    if (apt_time !== undefined)       { fields.push("apt_time = ?");       params.push(apt_time); }
    if (contact_person !== undefined) { fields.push("contact_person = ?"); params.push(contact_person); }
    if (contact_phone !== undefined)  { fields.push("contact_phone = ?");  params.push(contact_phone); }
    if (status !== undefined)         { fields.push("status = ?");         params.push(status); }

    if (!fields.length) {
      return res.status(400).json({ message: "No fields to update" });
    }

    const q2 = `
      UPDATE appointments
      SET ${fields.join(", ")}
      WHERE id = ?
      LIMIT 1
    `;
    params.push(appointmentId);

    db.query(q2, params, (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: "Appointment updated" });
    });
  });
};


export const deleteAppointment = (req, res) => {
  const { appointmentId } = req.params;

  const q = `
    DELETE a
    FROM appointments a
    JOIN moves m ON m.id = a.move_id
    WHERE a.id = ? AND m.user_id = ?
    LIMIT 1
  `;
  db.query(q, [appointmentId, req.user.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Appointment not found" });
    }
    res.json({ message: "Appointment deleted" });
  });
};
