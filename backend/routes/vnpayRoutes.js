import express from "express";
import {
  createPaymentUrl,
  vnpayReturn,
} from "../controller/vnpayController.js";

const router = express.Router();

router.get("/create_payment_url", createPaymentUrl);
router.get("/vnpay_return", vnpayReturn);

export default router;
