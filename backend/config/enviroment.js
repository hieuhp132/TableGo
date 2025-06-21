import dotenv from "dotenv";
dotenv.config();
const env = {
  DATA_URI: process.env.MONGODB_URI,
  DATABASE_NAME: process.env.DATA_NAME,
  APP_PORT: process.env.PORT,
  VNP_TMNCODE: process.env.VNPTMNCODE,
  VNP_HASHSECRET: process.env.VNPHASHSECRET,
  VNP_URL: process.env.VNPURL,
  VNP_RETURNURL: process.env.VNPRETURNURL,
};

export { env };
