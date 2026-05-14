class ExerciseIdea {
  final String name;
  final String description;

  ExerciseIdea({
    required this.name,
    required this.description,
  });

  factory ExerciseIdea.fromJson(Map<String, dynamic> json) {
    return ExerciseIdea(
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Unnamed Exercise',
      description: (json['description'] as String?)?.trim().isNotEmpty == true
          ? _cleanHtml(json['description'] as String)
          : 'No description available.',
    );
  }

  static String _cleanHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}