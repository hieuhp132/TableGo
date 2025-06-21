import { env } from "./enviroment.js";
import { MongoClient, ServerApiVersion } from "mongodb";

let DatabaseInstance = null; //intial data
const mongoClientInstance = new MongoClient(env.DATA_URI, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
  socketTimeoutMS: 45000, // Thời gian tối đa cho một yêu cầu
  serverSelectionTimeoutMS: 5000,
});
export const CONNECT_DB = async () => {
  try {
    console.log("Connecting to database...");
    await mongoClientInstance.connect();
    console.log("✅ Connected successfully to database");
    DatabaseInstance = mongoClientInstance.db("databaseorderapp");
  } catch (error) {
    console.error("❌ MongoDB connection error:", error.message); // Log chi tiết lỗi
    throw new Error("Database connection failed");
  }
};
//only called when completed connected
export const GET_DB = () => {
  if (!DatabaseInstance) throw new Error("Must connect to Database first");
  return DatabaseInstance;
};

export const CLOSE_DB = async () => {
  await mongoClientInstance.close();
};
