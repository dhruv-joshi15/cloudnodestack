const express = require('express');
const router = express.Router();

router.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

router.get('/status', (req, res) => {
  res.send('Running');
});

module.exports = router;
