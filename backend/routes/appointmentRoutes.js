import express from "express";
import { requireAuth } from "../middleware/authMiddleware.js";
import {
  listAppointmentsByMove,
  createAppointment,
  getAppointment,
  updateAppointment,
  deleteAppointment
} from "../controllers/appointmentsController.js";

const router = express.Router();


router.use(requireAuth);


router.get("/moves/:moveId/appointments", listAppointmentsByMove);
router.post("/moves/:moveId/appointments", createAppointment);


router.get("/appointments/:appointmentId", getAppointment);
router.patch("/appointments/:appointmentId", updateAppointment);
router.delete("/appointments/:appointmentId", deleteAppointment);

export default router;
