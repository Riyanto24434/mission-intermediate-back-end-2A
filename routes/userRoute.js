const express = require('express');
const router = express.Router();
const userService = require('../services/userService');

router.get('/users', async (req, res) => {
  const users = await userService.getAllUsers();
  res.json(users);
});

module.exports = router;
