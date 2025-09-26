const express = require("express");
const app = express();

const message = process.env.MESSAGE || "Hello from Node.js + Docker + K8s!";

app.get("/", (req, res) => {
  res.send(message);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

