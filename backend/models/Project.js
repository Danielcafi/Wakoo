const mongoose = require('mongoose');

const constructionStepSchema = new mongoose.Schema({
  stepId: {
    type: Number,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'in_progress', 'completed'],
    default: 'pending'
  },
  startDate: {
    type: Date,
    default: null
  },
  endDate: {
    type: Date,
    default: null
  },
  images: [{
    url: String,
    caption: String,
    uploadedAt: { type: Date, default: Date.now }
  }],
  materials: [{
    name: String,
    quantity: Number,
    unit: String,
    cost: Number
  }],
  notes: String
});

const projectSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Le titre du projet est requis'],
    trim: true,
    maxlength: [100, 'Le titre ne peut pas dépasser 100 caractères']
  },
  description: {
    type: String,
    required: [true, 'La description est requise'],
    trim: true,
    maxlength: [1000, 'La description ne peut pas dépasser 1000 caractères']
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  architect: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  constructor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  location: {
    address: {
      type: String,
      required: true
    },
    city: {
      type: String,
      required: true
    },
    department: {
      type: String,
      required: true
    },
    coordinates: {
      lat: Number,
      lng: Number
    }
  },
  propertyType: {
    type: String,
    enum: ['maison', 'appartement', 'villa', 'bureau', 'commerce'],
    required: true
  },
  constructionType: {
    type: String,
    enum: ['neuf', 'renovation', 'extension'],
    required: true
  },
  budget: {
    estimated: {
      type: Number,
      required: true
    },
    actual: {
      type: Number,
      default: 0
    },
    currency: {
      type: String,
      default: 'XOF'
    }
  },
  timeline: {
    startDate: {
      type: Date,
      required: true
    },
    endDate: {
      type: Date,
      required: true
    },
    duration: {
      type: Number, // en jours
      required: true
    }
  },
  status: {
    type: String,
    enum: ['planning', 'in_progress', 'on_hold', 'completed', 'cancelled'],
    default: 'planning'
  },
  steps: [constructionStepSchema],
  media: {
    images: [{
      url: String,
      caption: String,
      isMain: { type: Boolean, default: false },
      uploadedAt: { type: Date, default: Date.now }
    }],
    videos: [{
      url: String,
      caption: String,
      duration: Number,
      uploadedAt: { type: Date, default: Date.now }
    }],
    documents: [{
      url: String,
      name: String,
      type: String,
      uploadedAt: { type: Date, default: Date.now }
    }]
  },
  unityScene: {
    sceneUrl: String,
    version: String,
    lastUpdated: Date
  },
  progress: {
    percentage: {
      type: Number,
      default: 0,
      min: 0,
      max: 100
    },
    lastUpdated: {
      type: Date,
      default: Date.now
    }
  },
  isPublic: {
    type: Boolean,
    default: false
  },
  tags: [String]
}, {
  timestamps: true
});

// Index pour les recherches
projectSchema.index({ title: 'text', description: 'text' });
projectSchema.index({ location: 1 });
projectSchema.index({ status: 1 });
projectSchema.index({ owner: 1 });

// Méthode pour calculer le progrès
projectSchema.methods.calculateProgress = function() {
  if (this.steps.length === 0) return 0;
  
  const completedSteps = this.steps.filter(step => step.status === 'completed').length;
  return Math.round((completedSteps / this.steps.length) * 100);
};

// Middleware pour mettre à jour le progrès
projectSchema.pre('save', function(next) {
  this.progress.percentage = this.calculateProgress();
  this.progress.lastUpdated = new Date();
  next();
});

module.exports = mongoose.model('Project', projectSchema);
