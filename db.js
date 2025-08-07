const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '@r!S-24434',
  database: 'edu_course',
  port: 3306
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to database');
});

module.exports = connection;
