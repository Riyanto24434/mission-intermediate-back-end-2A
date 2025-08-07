const db = require('./db');
exports.getAllCourses = (callback) => {
  db.query('SELECT * FROM courses', callback);
};
exports.getCourseById = (id, callback) => {
  db.query('SELECT * FROM courses WHERE id = ?', [id], callback);
};
exports.addCourse = (data, callback) => {
  db.query('INSERT INTO courses SET ?', data, callback);
};
exports.updateCourse = (id, data, callback) => {
  db.query('UPDATE courses SET ? WHERE id = ?', [data, id], callback);
};
exports.deleteCourse = (id, callback) => {
  db.query('DELETE FROM courses WHERE id = ?', [id], callback);
};
