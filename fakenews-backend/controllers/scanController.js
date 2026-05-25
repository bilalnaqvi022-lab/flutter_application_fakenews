const Scan = require("../models/Scan");

exports.createScan = async (req, res) => {
  const scan = await Scan.create(req.body);

  res.json({
    success: true,
    data: scan,
  });
};

exports.getScans = async (req, res) => {
  const scans = await Scan.find();

  res.json(scans);
};