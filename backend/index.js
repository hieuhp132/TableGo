import express from "express";
import { env } from "./config/enviroment.js";
import { CONNECT_DB } from "./config/mongodb.js";
import cors from "cors";
import route from "./routes/index.js";
const port = env.APP_PORT;
const START_SERVER = () => {
  const app = express();
  // mongoose.set("debug", true);
  app.use(express.json());
  app.use(cors());
  route(app);
  app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
  });
};

// START_SERVER();

(async () => {
  try {
    await CONNECT_DB();
    START_SERVER();
  } catch (error) {
    console.error(error);
    process.exit(0);
  }
})();
