// routes/courseRoute.js
const express = require('express');
const router = express.Router();
const courseService = require('../services/courseService');

// GET all courses
router.get('/course', async (req, res) => {
  try {
    const courses = await courseService.getAllCourses();
    res.json(courses);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET course by ID
router.get('/course/:id', async (req, res) => {
  try {
    const course = await courseService.getCourseById(req.params.id);
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }
    res.json(course);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST create course
router.post('/course', async (req, res) => {
  try {
    const result = await courseService.addCourse(req.body);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH update course
router.patch('/course/:id', async (req, res) => {
  try {
    await courseService.updateCourse(req.params.id, req.body);
    res.json({ message: 'Course updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE course
router.delete('/course/:id', async (req, res) => {
  try {
    await courseService.deleteCourse(req.params.id);
    res.json({ message: 'Course deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
