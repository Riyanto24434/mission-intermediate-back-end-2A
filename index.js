const express = require('express');
const bodyParser = require('body-parser');
const courseRoutes = require('./courseRoute'); // pastikan nama file sesuai
const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());

// Routes
app.use('/', courseRoutes);

// Server start
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
