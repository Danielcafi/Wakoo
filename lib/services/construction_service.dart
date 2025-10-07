import 'dart:async';
import 'package:flutter/services.dart';
import '../models/construction_step.dart';

class ConstructionService {
  static const MethodChannel _channel = MethodChannel('construction_channel');
  
  final List<ConstructionStep> _steps = [
    ConstructionStep(
      id: 0,
      name: 'Fondation',
      description: 'Préparation du terrain et coulage de la fondation',
      imageUrl: 'assets/images/foundation.jpg',
      duration: const Duration(seconds: 3),
      materials: ['Béton', 'Acier', 'Gravier'],
      unityObjectName: 'Foundation',
    ),
    ConstructionStep(
      id: 1,
      name: 'Murs',
      description: 'Élévation des murs porteurs',
      imageUrl: 'assets/images/walls.jpg',
      duration: const Duration(seconds: 4),
      materials: ['Briques', 'Mortier', 'Isolation'],
      unityObjectName: 'Walls',
    ),
    ConstructionStep(
      id: 2,
      name: 'Toit',
      description: 'Pose de la charpente et de la toiture',
      imageUrl: 'assets/images/roof.jpg',
      duration: const Duration(seconds: 3),
      materials: ['Bois', 'Tuiles', 'Isolation'],
      unityObjectName: 'Roof',
    ),
  ];

  List<ConstructionStep> get steps => List.unmodifiable(_steps);
  
  int get currentStepIndex {
    for (int i = 0; i < _steps.length; i++) {
      if (!_steps[i].isCompleted) return i;
    }
    return _steps.length - 1;
  }

  ConstructionStep get currentStep => _steps[currentStepIndex];
  
  double get progress {
    int completedSteps = _steps.where((step) => step.isCompleted).length;
    return completedSteps / _steps.length;
  }

  Future<void> playStep(int stepIndex) async {
    if (stepIndex < 0 || stepIndex >= _steps.length) return;
    
    try {
      await _channel.invokeMethod('playStep', {'stepIndex': stepIndex});
    } catch (e) {
      print('Erreur lors de la lecture de l\'étape: $e');
    }
  }

  Future<void> playAllSteps() async {
    try {
      await _channel.invokeMethod('playAllSteps');
    } catch (e) {
      print('Erreur lors de la lecture de toutes les étapes: $e');
    }
  }

  Future<void> resetConstruction() async {
    try {
      await _channel.invokeMethod('resetConstruction');
      // Réinitialiser l'état local
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = _steps[i].copyWith(isCompleted: false, isActive: false);
      }
    } catch (e) {
      print('Erreur lors de la réinitialisation: $e');
    }
  }

  void markStepCompleted(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= _steps.length) return;
    
    _steps[stepIndex] = _steps[stepIndex].copyWith(isCompleted: true, isActive: false);
    
    // Activer l'étape suivante si elle existe
    if (stepIndex + 1 < _steps.length) {
      _steps[stepIndex + 1] = _steps[stepIndex + 1].copyWith(isActive: true);
    }
  }

  void setStepActive(int stepIndex) {
    // Désactiver toutes les étapes
    for (int i = 0; i < _steps.length; i++) {
      _steps[i] = _steps[i].copyWith(isActive: false);
    }
    
    // Activer l'étape sélectionnée
    if (stepIndex >= 0 && stepIndex < _steps.length) {
      _steps[stepIndex] = _steps[stepIndex].copyWith(isActive: true);
    }
  }
}
