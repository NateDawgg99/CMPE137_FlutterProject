import 'package:flutter/material.dart';

class DiscoveryWorkout {
  final String title;
  final String focus;
  final String difficulty;
  final List<DiscoveryExercise> exercises;

  const DiscoveryWorkout({
    required this.title,
    required this.focus,
    required this.difficulty,
    required this.exercises,
  });
}

class DiscoveryExercise {
  final String name;
  final String targetArea;
  final String equipment;
  final String instructions;

  const DiscoveryExercise({
    required this.name,
    required this.targetArea,
    required this.equipment,
    required this.instructions,
  });
}

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  final List<DiscoveryWorkout> workouts = const [
    DiscoveryWorkout(
      title: 'Beginner Leg Day',
      focus: 'Quads, Hamstrings, Glutes, Calves',
      difficulty: 'Beginner',
      exercises: [
        DiscoveryExercise(
          name: 'Leg Press',
          targetArea: 'Quads and Glutes',
          equipment: 'Leg Press Machine',
          instructions: '3 sets of 10 reps. Keep your feet flat and do not lock your knees.',
        ),
        DiscoveryExercise(
          name: 'Seated Hamstring Curl',
          targetArea: 'Hamstrings',
          equipment: 'Hamstring Curl Machine',
          instructions: '3 sets of 12 reps. Control the movement and avoid swinging.',
        ),
        DiscoveryExercise(
          name: 'Standing Calf Raise',
          targetArea: 'Calves',
          equipment: 'Calf Raise Machine',
          instructions: '3 sets of 15 reps. Pause briefly at the top of each rep.',
        ),
      ],
    ),
    DiscoveryWorkout(
      title: 'Push Day Machines',
      focus: 'Chest, Shoulders, Triceps',
      difficulty: 'Beginner',
      exercises: [
        DiscoveryExercise(
          name: 'Machine Chest Press',
          targetArea: 'Chest',
          equipment: 'Chest Press Machine',
          instructions: '3 sets of 10 reps. Keep your back against the pad.',
        ),
        DiscoveryExercise(
          name: 'Shoulder Press',
          targetArea: 'Shoulders',
          equipment: 'Shoulder Press Machine',
          instructions: '3 sets of 10 reps. Press upward without shrugging.',
        ),
        DiscoveryExercise(
          name: 'Triceps Pushdown',
          targetArea: 'Triceps',
          equipment: 'Cable Machine',
          instructions: '3 sets of 12 reps. Keep elbows close to your sides.',
        ),
      ],
    ),
    DiscoveryWorkout(
      title: 'Pull Day Machines',
      focus: 'Back and Biceps',
      difficulty: 'Beginner',
      exercises: [
        DiscoveryExercise(
          name: 'Lat Pulldown',
          targetArea: 'Lats and Upper Back',
          equipment: 'Lat Pulldown Machine',
          instructions: '3 sets of 10 reps. Pull the bar toward your upper chest.',
        ),
        DiscoveryExercise(
          name: 'Seated Cable Row',
          targetArea: 'Middle Back',
          equipment: 'Cable Row Machine',
          instructions: '3 sets of 10 reps. Pull handles toward your torso.',
        ),
        DiscoveryExercise(
          name: 'Cable Bicep Curl',
          targetArea: 'Biceps',
          equipment: 'Cable Machine',
          instructions: '3 sets of 12 reps. Keep elbows still while curling.',
        ),
      ],
    ),
    DiscoveryWorkout(
      title: 'Glute Focus Day',
      focus: 'Glutes and Hamstrings',
      difficulty: 'Intermediate',
      exercises: [
        DiscoveryExercise(
          name: 'Hip Thrust Machine',
          targetArea: 'Glutes',
          equipment: 'Hip Thrust Machine',
          instructions: '3 sets of 10 reps. Squeeze glutes at the top.',
        ),
        DiscoveryExercise(
          name: 'Cable Kickback',
          targetArea: 'Glutes',
          equipment: 'Cable Machine',
          instructions: '3 sets of 12 reps per leg. Keep the motion controlled.',
        ),
        DiscoveryExercise(
          name: 'Seated Hamstring Curl',
          targetArea: 'Hamstrings',
          equipment: 'Hamstring Curl Machine',
          instructions: '3 sets of 12 reps. Use a slow return.',
        ),
      ],
    ),
    DiscoveryWorkout(
      title: 'Core Machine Circuit',
      focus: 'Abs and Core Stability',
      difficulty: 'Beginner',
      exercises: [
        DiscoveryExercise(
          name: 'Ab Crunch Machine',
          targetArea: 'Upper Abs',
          equipment: 'Ab Crunch Machine',
          instructions: '3 sets of 12 reps. Crunch slowly and avoid pulling with your arms.',
        ),
        DiscoveryExercise(
          name: 'Torso Rotation',
          targetArea: 'Obliques',
          equipment: 'Torso Rotation Machine',
          instructions: '3 sets of 10 reps per side. Rotate with control.',
        ),
        DiscoveryExercise(
          name: 'Cable Woodchop',
          targetArea: 'Core and Obliques',
          equipment: 'Cable Machine',
          instructions: '3 sets of 10 reps per side. Keep your core tight.',
        ),
      ],
    ),
  ];

  void _showWorkoutDetails(BuildContext context, DiscoveryWorkout workout) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workout.focus,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),

                for (final exercise in workout.exercises)
                  Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.fitness_center,
                          color: Colors.green.shade800,
                        ),
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Target: ${exercise.targetArea}\n'
                              'Equipment: ${exercise.equipment}\n'
                              '${exercise.instructions}',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => _showWorkoutDetails(context, workout),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.sports_gymnastics,
                      color: Colors.green.shade800,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          workout.focus,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${workout.exercises.length} exercises • ${workout.difficulty}',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}