import express from "express";
import {
  createOrder,
  getAllOrders,
  getOrder,
  updateOrder,
  deleteOrder,
} from "../controller/orderController.js";

const router = express.Router();

router.post("/create", createOrder);
router.get("/show", getAllOrders);
router.get("/:id", getOrder);
router.put("/update/:id", updateOrder);
router.delete("/delete/:id", deleteOrder);

export default router;
