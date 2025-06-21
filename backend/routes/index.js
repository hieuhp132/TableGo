// route the part of routing
import orderRoutes from "./orderRoutes.js";
import vnpayRoutes from "./vnpayRoutes.js";
export default function route(app) {
  app.use("/api/order", orderRoutes);
  app.use("/vnpay", vnpayRoutes);
  //app.use();
}
