const mongoose = require("mongoose");

const scanSchema = new mongoose.Schema({
  extractedText: String,
  credibility: String,
  score: Number,
  explanation: String,
  detectedClaims: [String],
});

module.exports = mongoose.model("Scan", scanSchema);