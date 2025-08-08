// courseService.js
const db = require('../db');

exports.getAllCourses = async () => {
  const [rows] = await db.query('SELECT * FROM produk_kelas');
  return rows;
};

exports.getCourseById = async (id) => {
  const [rows] = await db.query('SELECT * FROM produk_kelas WHERE id = ?', [id]);
  return rows[0] || null;
};

exports.addCourse = async (data) => {
  const [result] = await db.query('INSERT INTO produk_kelas SET ?', data);
  return result.insertId;
};

exports.updateCourse = async (id, data) => {
  await db.query('UPDATE produk_kelas SET ? WHERE id = ?', [data, id]);
  return { message: 'Course updated' };
};

exports.deleteCourse = async (id) => {
  await db.query('DELETE FROM produk_kelas WHERE id = ?', [id]);
  return { message: 'Course deleted' };
};

