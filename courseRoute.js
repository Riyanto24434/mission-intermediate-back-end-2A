const express = require('express');
const router = express.Router();
const courseService = require('./courseService');

router.get('/course', (req, res) => {
  courseService.getAllCourses((err, result) => {
    if (err) return res.status(500).send(err);
    res.json(result);
  });
});

router.get('/course/:id', (req, res) => {
  courseService.getCourseById(req.params.id, (err, result) => {
    if (err) return res.status(500).send(err);
    res.json(result[0]);
  });
});

router.post('/course', (req, res) => {
  courseService.addCourse(req.body, (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ id: result.insertId });
  });
});

router.patch('/course/:id', (req, res) => {
  courseService.updateCourse(req.params.id, req.body, (err) => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Course updated' });
  });
});

router.delete('/course/:id', (req, res) => {
  courseService.deleteCourse(req.params.id, (err) => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Course deleted' });
  });
});

module.exports = router;
