import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class AnimationService {
  static final AnimationService _instance = AnimationService._internal();
  factory AnimationService() => _instance;
  AnimationService._internal();

  // Cache pour les animations
  final Map<String, RiveAnimationController> _riveControllers = {};
  final Map<String, LottieComposition> _lottieCompositions = {};
  
  // Contrôleurs d'animation
  final Map<String, AnimationController> _animationControllers = {};
  
  // Performance monitoring
  final List<PerformanceMetric> _performanceMetrics = [];
  
  // Configuration des animations
  static const Duration _defaultDuration = Duration(milliseconds: 300);
  static const Curve _defaultCurve = Curves.easeInOut;

  // Initialiser une animation Rive
  Future<RiveAnimationController> initRiveAnimation(
    String assetPath, {
    String? stateMachineName,
    String? artboardName,
  }) async {
    if (_riveControllers.containsKey(assetPath)) {
      return _riveControllers[assetPath]!;
    }

    try {
      final controller = RiveAnimationController();
      await controller.loadAsset(assetPath);
      
      if (stateMachineName != null) {
        controller.setStateMachine(stateMachineName);
      }
      
      _riveControllers[assetPath] = controller;
      return controller;
    } catch (e) {
      print('Erreur lors du chargement de l\'animation Rive: $e');
      rethrow;
    }
  }

  // Initialiser une animation Lottie
  Future<LottieComposition> initLottieAnimation(String assetPath) async {
    if (_lottieCompositions.containsKey(assetPath)) {
      return _lottieCompositions[assetPath]!;
    }

    try {
      final composition = await LottieComposition.fromAsset(assetPath);
      _lottieCompositions[assetPath] = composition;
      return composition;
    } catch (e) {
      print('Erreur lors du chargement de l\'animation Lottie: $e');
      rethrow;
    }
  }

  // Créer un contrôleur d'animation
  AnimationController createAnimationController(
    TickerProvider vsync,
    String key, {
    Duration duration = _defaultDuration,
    Duration? reverseDuration,
  }) {
    if (_animationControllers.containsKey(key)) {
      return _animationControllers[key]!;
    }

    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      vsync: vsync,
    );
    
    _animationControllers[key] = controller;
    return controller;
  }

  // Animation de fade in
  Animation<double> createFadeInAnimation(
    AnimationController controller, {
    Curve curve = _defaultCurve,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de slide in
  Animation<Offset> createSlideInAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
    Curve curve = _defaultCurve,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de scale
  Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = _defaultCurve,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de rotation
  Animation<double> createRotationAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = _defaultCurve,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de progression
  Animation<double> createProgressAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = _defaultCurve,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de construction étape par étape
  Animation<double> createConstructionStepAnimation(
    AnimationController controller,
    int stepIndex,
    int totalSteps, {
    Curve curve = _defaultCurve,
  }) {
    final stepProgress = stepIndex / totalSteps;
    final nextStepProgress = (stepIndex + 1) / totalSteps;
    
    return Tween<double>(
      begin: stepProgress,
      end: nextStepProgress,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de vibration
  Animation<Offset> createShakeAnimation(
    AnimationController controller, {
    double intensity = 10.0,
    Curve curve = Curves.elasticIn,
  }) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: Offset(intensity, 0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de pulsation
  Animation<double> createPulseAnimation(
    AnimationController controller, {
    double minScale = 0.8,
    double maxScale = 1.2,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animation de rebond
  Animation<double> createBounceAnimation(
    AnimationController controller, {
    double intensity = 0.3,
    Curve curve = Curves.elasticOut,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: intensity,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Mesurer les performances
  void startPerformanceMeasurement(String animationName) {
    _performanceMetrics.add(PerformanceMetric(
      name: animationName,
      startTime: DateTime.now(),
    ));
  }

  void endPerformanceMeasurement(String animationName) {
    final metric = _performanceMetrics.firstWhere(
      (m) => m.name == animationName && m.endTime == null,
      orElse: () => throw Exception('Métrique non trouvée'),
    );
    
    metric.endTime = DateTime.now();
    metric.duration = metric.endTime!.difference(metric.startTime);
    
    print('Animation $animationName: ${metric.duration.inMilliseconds}ms');
  }

  // Nettoyer les ressources
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    _animationControllers.clear();
    _riveControllers.clear();
    _lottieCompositions.clear();
  }

  // Obtenir les métriques de performance
  List<PerformanceMetric> getPerformanceMetrics() => List.unmodifiable(_performanceMetrics);
}

class PerformanceMetric {
  final String name;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;

  PerformanceMetric({
    required this.name,
    required this.startTime,
  });
}
