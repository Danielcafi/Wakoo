import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityWidgetWrapper extends StatefulWidget {
  final Function(String, String, dynamic)? onUnityMessage;
  final Function()? onUnityReady;
  final Function()? onUnityUnloaded;

  const UnityWidgetWrapper({
    super.key,
    this.onUnityMessage,
    this.onUnityReady,
    this.onUnityUnloaded,
  });

  @override
  State<UnityWidgetWrapper> createState() => _UnityWidgetWrapperState();
}

class _UnityWidgetWrapperState extends State<UnityWidgetWrapper> {
  UnityWidgetController? _unityWidgetController;
  bool _isUnityReady = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: UnityWidget(
          onUnityCreated: _onUnityCreated,
          onUnityMessage: _onUnityMessage,
          onUnityUnloaded: _onUnityUnloaded,
          useAndroidViewSurface: true,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onUnityCreated(UnityWidgetController controller) {
    setState(() {
      _unityWidgetController = controller;
      _isUnityReady = true;
    });
    widget.onUnityReady?.call();
  }

  void _onUnityMessage(message) {
    widget.onUnityMessage?.call(
      message.toString(),
      '',
      message,
    );
  }

  void _onUnityUnloaded() {
    setState(() {
      _isUnityReady = false;
    });
    widget.onUnityUnloaded?.call();
  }

  // Méthodes publiques pour contrôler Unity
  void playStep(int stepIndex) {
    if (_isUnityReady && _unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'ConstructionController',
        'PlayStep',
        stepIndex.toString(),
      );
    }
  }

  void playAllSteps() {
    if (_isUnityReady && _unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'ConstructionController',
        'PlayAllSteps',
        '',
      );
    }
  }

  void resetConstruction() {
    if (_isUnityReady && _unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'ConstructionController',
        'ResetConstruction',
        '',
      );
    }
  }

  void setStepDelay(double delay) {
    if (_isUnityReady && _unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'ConstructionController',
        'SetStepDelay',
        delay.toString(),
      );
    }
  }

  bool get isReady => _isUnityReady;
}
