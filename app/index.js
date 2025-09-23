import express from 'express';
import os from 'os';

const app = express();
const PORT = process.env.PORT || 3000;
const MESSAGE = process.env.MESSAGE || 'Hello from Node.js on Kubernetes!';

app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.get('/', (req, res) => {
  res.status(200).json({
    message: MESSAGE,
    hostname: os.hostname(),
    time: new Date().toISOString(),
  });
});

// Basic error route for testing liveness/readiness behavior
app.get('/error', (req, res) => {
  res.status(500).json({ error: 'Intentional error for testing' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
