class ConstructionStep {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isCompleted;
  final bool isActive;
  final Duration duration;
  final List<String> materials;
  final String unityObjectName;

  ConstructionStep({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isCompleted = false,
    this.isActive = false,
    required this.duration,
    required this.materials,
    required this.unityObjectName,
  });

  ConstructionStep copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isCompleted,
    bool? isActive,
    Duration? duration,
    List<String>? materials,
    String? unityObjectName,
  }) {
    return ConstructionStep(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      duration: duration ?? this.duration,
      materials: materials ?? this.materials,
      unityObjectName: unityObjectName ?? this.unityObjectName,
    );
  }
}
