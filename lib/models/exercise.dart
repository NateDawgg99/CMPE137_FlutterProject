class Exercise {
  final int? id;
  final int workoutId;
  final String name;
  final String targetArea;
  final String equipment;
  final String instructions;

  Exercise({
    this.id,
    required this.workoutId,
    required this.name,
    required this.targetArea,
    required this.equipment,
    required this.instructions,
  });

  Exercise copyWith({
    int? id,
    int? workoutId,
    String? name,
    String? targetArea,
    String? equipment,
    String? instructions,
  }) {
    return Exercise(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      name: name ?? this.name,
      targetArea: targetArea ?? this.targetArea,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutId': workoutId,
      'name': name,
      'targetArea': targetArea,
      'equipment': equipment,
      'instructions': instructions,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      workoutId: map['workoutId'] as int,
      name: map['name'] as String,
      targetArea: map['targetArea'] as String,
      equipment: map['equipment'] as String,
      instructions: map['instructions'] as String,
    );
  }
}