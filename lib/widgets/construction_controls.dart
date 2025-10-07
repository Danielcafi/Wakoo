import 'package:flutter/material.dart';
import '../models/construction_step.dart';
import '../services/construction_service.dart';

class ConstructionControls extends StatefulWidget {
  final ConstructionService constructionService;
  final Function(int) onStepSelected;
  final Function() onPlayAll;
  final Function() onReset;

  const ConstructionControls({
    super.key,
    required this.constructionService,
    required this.onStepSelected,
    required this.onPlayAll,
    required this.onReset,
  });

  @override
  State<ConstructionControls> createState() => _ConstructionControlsState();
}

class _ConstructionControlsState extends State<ConstructionControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressBar(),
          const SizedBox(height: 16),
          _buildStepList(),
          const SizedBox(height: 16),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression de la construction',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: widget.constructionService.progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
        ),
        const SizedBox(height: 4),
        Text(
          '${(widget.constructionService.progress * 100).toInt()}% terminé',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étapes de construction',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.constructionService.steps.asMap().entries.map((entry) {
          int index = entry.key;
          ConstructionStep step = entry.value;
          return _buildStepItem(step, index);
        }).toList(),
      ],
    );
  }

  Widget _buildStepItem(ConstructionStep step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => widget.onStepSelected(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: step.isActive ? Colors.blue[50] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: step.isActive ? Colors.blue[300]! : Colors.grey[300]!,
              width: step.isActive ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: step.isCompleted ? Colors.green : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: step.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: step.isActive ? Colors.blue[700] : Colors.black87,
                      ),
                    ),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (step.isActive)
                Icon(
                  Icons.play_arrow,
                  color: Colors.blue[600],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onPlayAll,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Tout jouer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Réinitialiser'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
