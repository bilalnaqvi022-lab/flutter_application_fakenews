const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

mongoose.connect("mongodb://127.0.0.1:27017/fake_news");

app.use("/api/scans", require("./routes/scanRoutes"));

app.listen(5000, () => {
  console.log("Server Running");
});