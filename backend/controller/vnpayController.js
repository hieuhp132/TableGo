import crypto from "crypto";
import qs from "qs";
import moment from "moment-timezone";
import { env } from "../config/enviroment.js";

const vnp_TmnCode = env.VNP_TMNCODE;
const vnp_HashSecret = env.VNP_HASHSECRET;
const vnp_Url = env.VNP_URL;
const vnp_ReturnUrl = env.VNP_RETURNURL;
//http://localhost:3000/vnpay/create_payment_url?amount=10000
export const createPaymentUrl = (req, res) => {
  const ipAddr =
    req.headers["x-forwarded-for"]?.split(",")[0]?.trim() ||
    req.socket?.remoteAddress?.replace("::ffff:", "") ||
    "127.0.0.1";

  const date = moment().tz("Asia/Ho_Chi_Minh");
  const orderId = date.format("YYYYMMDDHHmmss");
  const amount = Number(req.query.amount || 10000);
  const expireDate = date.clone().add(15, "minutes");
  let vnp_Params = {
    vnp_Version: "2.1.0",
    vnp_Command: "pay",
    vnp_TmnCode,
    vnp_Locale: "vn",
    vnp_CurrCode: "VND",
    vnp_TxnRef: orderId,
    vnp_OrderInfo: `Thanhtoandonhang${orderId}`,
    vnp_OrderType: "other",
    vnp_Amount: amount * 100,
    vnp_ReturnUrl,
    vnp_IpAddr: ipAddr,
    vnp_CreateDate: date.format("YYYYMMDDHHmmss"),
    vnp_ExpireDate: expireDate.format("YYYYMMDDHHmmss"),
  };
  delete vnp_Params["vnp_SecureHash"];
  const sortedParams = sortObject(vnp_Params);
  const signData = qs.stringify(sortedParams, { encode: true });
  const hmac = crypto.createHmac("sha512", vnp_HashSecret);
  const signed = hmac.update(Buffer.from(signData, "utf-8")).digest("hex");

  sortedParams["vnp_SecureHash"] = signed;

  const paymentUrl =
    vnp_Url + "?" + qs.stringify(sortedParams, { encode: false });
  res.redirect(paymentUrl);
};

export const vnpayReturn = (req, res) => {
  const query = req.query;
  const responseCode = query.vnp_ResponseCode;

  if (responseCode === "00") {
    return res.send("✅ Giao dịch thành công!");
  } else {
    return res.send("❌ Giao dịch thất bại hoặc bị hủy.");
  }
};

function sortObject(obj) {
  const sorted = {};
  const keys = Object.keys(obj).sort();
  for (let key of keys) {
    sorted[key] = obj[key];
  }
  return sorted;
}
