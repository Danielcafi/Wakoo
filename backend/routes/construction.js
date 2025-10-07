const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');
const {
  createProject,
  getProjects,
  getProject,
  updateProject,
  updateStep,
  deleteProject,
} = require('../controllers/constructionController');

// Toutes les routes nécessitent une authentification
router.use(auth);

// Routes des projets
router.post('/', createProject);
router.get('/', getProjects);
router.get('/:id', getProject);
router.put('/:id', updateProject);
router.delete('/:id', deleteProject);

// Routes des étapes
router.put('/:projectId/steps/:stepId', updateStep);

module.exports = router;



