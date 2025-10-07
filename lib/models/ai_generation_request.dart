class AIGenerationRequest {
  final String projectId;
  final int stepId;
  final String prompt;
  final String? referenceImageUrl;
  final AIGenerationType type;
  final Map<String, dynamic> parameters;
  final String? seed;

  AIGenerationRequest({
    required this.projectId,
    required this.stepId,
    required this.prompt,
    this.referenceImageUrl,
    required this.type,
    this.parameters = const {},
    this.seed,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'stepId': stepId,
      'prompt': prompt,
      'referenceImageUrl': referenceImageUrl,
      'type': type.toString().split('.').last,
      'parameters': parameters,
      'seed': seed,
    };
  }

  factory AIGenerationRequest.fromJson(Map<String, dynamic> json) {
    return AIGenerationRequest(
      projectId: json['projectId'],
      stepId: json['stepId'],
      prompt: json['prompt'],
      referenceImageUrl: json['referenceImageUrl'],
      type: AIGenerationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AIGenerationType.textToImage,
      ),
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
      seed: json['seed'],
    );
  }
}

enum AIGenerationType {
  textToImage,
  imageToImage,
  imageVariation,
  styleTransfer,
}

class AIGenerationResponse {
  final String id;
  final String imageUrl;
  final String? seed;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final AIGenerationStatus status;

  AIGenerationResponse({
    required this.id,
    required this.imageUrl,
    this.seed,
    this.metadata = const {},
    required this.createdAt,
    required this.status,
  });

  factory AIGenerationResponse.fromJson(Map<String, dynamic> json) {
    return AIGenerationResponse(
      id: json['id'],
      imageUrl: json['imageUrl'],
      seed: json['seed'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      status: AIGenerationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AIGenerationStatus.pending,
      ),
    );
  }
}

enum AIGenerationStatus {
  pending,
  processing,
  completed,
  failed,
}
