const Project = require('../models/Project');

const createProject = async (req, res) => {
  try {
    const projectData = {
      ...req.body,
      owner: req.user._id,
    };

    const project = new Project(projectData);
    await project.save();

    res.status(201).json({
      message: 'Projet créé avec succès',
      project,
    });
  } catch (error) {
    console.error('Erreur lors de la création du projet:', error);
    res.status(500).json({ error: 'Erreur lors de la création du projet' });
  }
};

const getProjects = async (req, res) => {
  try {
    const { page = 1, limit = 10, status, search } = req.query;
    const query = { owner: req.user._id };

    if (status) query.status = status;
    if (search) {
      query.$text = { $search: search };
    }

    const projects = await Project.find(query)
      .populate('architect', 'firstName lastName email')
      .populate('constructor', 'firstName lastName email')
      .sort({ createdAt: -1 })
      .limit(Number(limit))
      .skip((Number(page) - 1) * Number(limit));

    const total = await Project.countDocuments(query);

    res.json({
      projects,
      totalPages: Math.ceil(total / Number(limit)),
      currentPage: Number(page),
      total,
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des projets:', error);
    res.status(500).json({ error: 'Erreur lors de la récupération des projets' });
  }
};

const getProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id)
      .populate('owner', 'firstName lastName email')
      .populate('architect', 'firstName lastName email')
      .populate('constructor', 'firstName lastName email');

    if (!project) {
      return res.status(404).json({ error: 'Projet non trouvé' });
    }

    if (project.owner._id.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: 'Accès refusé' });
    }

    res.json({ project });
  } catch (error) {
    console.error('Erreur lors de la récupération du projet:', error);
    res.status(500).json({ error: 'Erreur lors de la récupération du projet' });
  }
};

const updateProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({ error: 'Projet non trouvé' });
    }

    if (project.owner.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: 'Accès refusé' });
    }

    const updatedProject = await Project.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    res.json({
      message: 'Projet mis à jour avec succès',
      project: updatedProject,
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du projet:', error);
    res.status(500).json({ error: 'Erreur lors de la mise à jour du projet' });
  }
};

const updateStep = async (req, res) => {
  try {
    const { projectId, stepId } = req.params;
    const { status, images, materials, notes } = req.body;

    const project = await Project.findById(projectId);
    if (!project) {
      return res.status(404).json({ error: 'Projet non trouvé' });
    }

    if (project.owner.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: 'Accès refusé' });
    }

    const step = project.steps.find((s) => String(s.stepId) === String(stepId));
    if (!step) {
      return res.status(404).json({ error: 'Étape non trouvée' });
    }

    if (status) step.status = status;
    if (images) step.images = images;
    if (materials) step.materials = materials;
    if (notes) step.notes = notes;

    if (status === 'in_progress' && !step.startDate) {
      step.startDate = new Date();
    }

    if (status === 'completed' && !step.endDate) {
      step.endDate = new Date();
    }

    await project.save();

    res.json({
      message: 'Étape mise à jour avec succès',
      step,
      progress: project.progress,
    });
  } catch (error) {
    console.error("Erreur lors de la mise à jour de l'étape:", error);
    res.status(500).json({ error: "Erreur lors de la mise à jour de l'étape" });
  }
};

const deleteProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({ error: 'Projet non trouvé' });
    }

    if (project.owner.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: 'Accès refusé' });
    }

    await Project.findByIdAndDelete(req.params.id);

    res.json({ message: 'Projet supprimé avec succès' });
  } catch (error) {
    console.error('Erreur lors de la suppression du projet:', error);
    res.status(500).json({ error: 'Erreur lors de la suppression du projet' });
  }
};

module.exports = {
  createProject,
  getProjects,
  getProject,
  updateProject,
  updateStep,
  deleteProject,
};



