import { GET_DB } from "../config/mongodb.js";
import { ObjectId } from "mongodb";
import Order from "../model/order.model.js";

export const createOrder = async (req, res) => {
  try {
    const db = GET_DB();
    let { name, price, sales, category, status } = req.body;

    if (!status || status.trim() === "") {
      status = "Pending";
    }

    const orderData = {
      name,
      price,
      sales,
      category,
      status,
    };

    const result = await db.collection("order").insertOne(orderData);

    res.status(201).json({
      success: "Đã thêm",
      insertedId: result.insertedId,
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

export const getAllOrders = async (req, res) => {
  try {
    const db = GET_DB();
    const orders = await db.collection("order").find().toArray();
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getOrder = async (req, res) => {
  try {
    const db = GET_DB();
    const id = req.params.id;
    const order = await db
      .collection("order")
      .findOne({ _id: new ObjectId(id) });
    if (!order) return res.status(404).json({ error: "Order not found" });
    res.json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateOrder = async (req, res) => {
  try {
    const db = GET_DB();
    const id = req.params.id;

    if (!ObjectId.isValid(id)) {
      return res.status(400).json({ error: "Invalid ID format" });
    }
    const orderId = new ObjectId(id);

    const order = await db.collection("order").findOne({ _id: orderId });
    if (!order) return res.status(404).json({ error: "Order not found" });

    const { _id, ...updateData } = req.body;

    const result = await db
      .collection("order")
      .findOneAndUpdate(
        { _id: orderId },
        { $set: updateData },
        { returnDocument: "after" }
      );

    return res.json(result.value);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const deleteOrder = async (req, res) => {
  try {
    const db = GET_DB();
    const id = req.params.id;
    const result = await db
      .collection("order")
      .deleteOne({ _id: new ObjectId(id) });
    if (result.deletedCount === 0)
      return res.status(404).json({ error: "Order not found" });
    res.json({ message: "Order deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
