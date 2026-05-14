class Workout {
  final int? id;
  final String title;
  final String focusArea;
  final String notes;

  Workout({
    this.id,
    required this.title,
    required this.focusArea,
    required this.notes,
  });

  Workout copyWith({
    int? id,
    String? title,
    String? focusArea,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      focusArea: focusArea ?? this.focusArea,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'focusArea': focusArea,
      'notes': notes,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      title: map['title'] as String,
      focusArea: map['focusArea'] as String,
      notes: map['notes'] as String,
    );
  }
}