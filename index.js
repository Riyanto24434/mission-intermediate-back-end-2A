// index.js
const express = require('express'); 
const bodyParser = require('body-parser');
const courseRoutes = require('./routes/courseRoute'); 
require('./db');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use('/', courseRoutes);

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
