import 'package:flutter/material.dart';
import '../widgets/unity_widget_wrapper.dart';
import '../widgets/construction_controls.dart';
import '../services/construction_service.dart';
import 'step_detail_screen.dart';

class ConstructionScreen extends StatefulWidget {
  const ConstructionScreen({super.key});

  @override
  State<ConstructionScreen> createState() => _ConstructionScreenState();
}

class _ConstructionScreenState extends State<ConstructionScreen> {
  final ConstructionService _constructionService = ConstructionService();
  final GlobalKey<_UnityWidgetWrapperState> _unityKey = GlobalKey<_UnityWidgetWrapperState>();
  bool _isUnityReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction 3D'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Zone Unity 3D
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: _isUnityReady
                  ? UnityWidgetWrapper(
                      key: _unityKey,
                      onUnityReady: _onUnityReady,
                      onUnityMessage: _onUnityMessage,
                      onUnityUnloaded: _onUnityUnloaded,
                    )
                  : _buildUnityLoading(),
            ),
          ),
          // Contrôles
          Expanded(
            flex: 1,
            child: ConstructionControls(
              constructionService: _constructionService,
              onStepSelected: _onStepSelected,
              onPlayAll: _onPlayAll,
              onReset: _onReset,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnityLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement de la scène 3D...'),
          ],
        ),
      ),
    );
  }

  void _onUnityReady() {
    setState(() {
      _isUnityReady = true;
    });
  }

  void _onUnityMessage(String message, String data, dynamic args) {
    // Gérer les messages de Unity
    if (message.contains('StepCompleted')) {
      // Extraire l'index de l'étape
      final stepIndex = int.tryParse(data) ?? 0;
      _constructionService.markStepCompleted(stepIndex);
      setState(() {});
    }
  }

  void _onUnityUnloaded() {
    setState(() {
      _isUnityReady = false;
    });
  }

  void _onStepSelected(int stepIndex) {
    if (_isUnityReady) {
      _unityKey.currentState?.playStep(stepIndex);
      _constructionService.setStepActive(stepIndex);
      setState(() {});
    }
  }

  void _onPlayAll() {
    if (_isUnityReady) {
      _unityKey.currentState?.playAllSteps();
    }
  }

  void _onReset() {
    if (_isUnityReady) {
      _unityKey.currentState?.resetConstruction();
      _constructionService.resetConstruction();
      setState(() {});
    }
  }
}
