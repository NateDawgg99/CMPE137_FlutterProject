class ApiExercise {
  final String exerciseId;
  final String name;
  final String gifUrl;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  ApiExercise({
    required this.exerciseId,
    required this.name,
    required this.gifUrl,
    required this.targetMuscles,
    required this.bodyParts,
    required this.equipments,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory ApiExercise.fromJson(Map<String, dynamic> json) {
    return ApiExercise(
      exerciseId: json['exerciseId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Exercise',
      gifUrl: json['gifUrl']?.toString() ?? '',
      targetMuscles: _stringList(json['targetMuscles']),
      bodyParts: _stringList(json['bodyParts']),
      equipments: _stringList(json['equipments']),
      secondaryMuscles: _stringList(json['secondaryMuscles']),
      instructions: _stringList(json['instructions']),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    return [];
  }

  String get targetText {
    if (targetMuscles.isEmpty) return 'Unknown target';
    return targetMuscles.join(', ');
  }

  String get bodyPartText {
    if (bodyParts.isEmpty) return 'Unknown body part';
    return bodyParts.join(', ');
  }

  String get equipmentText {
    if (equipments.isEmpty) return 'Bodyweight / Unknown';
    return equipments.join(', ');
  }

  String get secondaryText {
    if (secondaryMuscles.isEmpty) return 'None listed';
    return secondaryMuscles.join(', ');
  }

  String get instructionText {
    if (instructions.isEmpty) {
      return 'No step-by-step instructions available.';
    }

    return instructions.join('\n\n');
  }
}