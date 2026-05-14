import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../app_model.dart';
import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  Future<List<Exercise>>? _exerciseFuture;

  @override
  void initState() {
    super.initState();
    _refreshExercises();
  }

  void _refreshExercises() {
    final model = ScopedModel.of<AppModel>(context);
    _exerciseFuture = model.getExercisesForWorkout(widget.workout.id!);
  }

  Future<void> _showAddExerciseDialog(AppModel model) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final equipmentController = TextEditingController();
    final instructionsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Exercise'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter exercise name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: targetController,
                    decoration: const InputDecoration(labelText: 'Target Area'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter target area';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: equipmentController,
                    decoration: const InputDecoration(labelText: 'Equipment'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter equipment';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: instructionsController,
                    decoration: const InputDecoration(labelText: 'Instructions'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter instructions';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                await model.addExercise(
                  Exercise(
                    workoutId: widget.workout.id!,
                    name: nameController.text.trim(),
                    targetArea: targetController.text.trim(),
                    equipment: equipmentController.text.trim(),
                    instructions: instructionsController.text.trim(),
                  ),
                );

                if (!mounted) return;

                setState(() {
                  _refreshExercises();
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    targetController.dispose();
    equipmentController.dispose();
    instructionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.workout.title),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddExerciseDialog(model),
            icon: const Icon(Icons.add),
            label: const Text('Exercise'),
          ),
          body: FutureBuilder<List<Exercise>>(
            future: _exerciseFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final exercises = snapshot.data ?? [];

              if (exercises.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Text(
                      'No exercises added yet.\nTap the Exercise button to add machines, movements, and target areas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Targets: ${exercise.targetArea}\nEquipment: ${exercise.equipment}\n${exercise.instructions}',
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await model.deleteExercise(exercise);

                          setState(() {
                            _refreshExercises();
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}