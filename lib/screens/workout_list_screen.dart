import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import '../app_model.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import 'workout_detail_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  Future<void> _deleteWorkout(
      BuildContext context,
      AppModel model,
      Workout workout,
      ) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    final List<Exercise> savedExercises = workout.id == null
        ? []
        : await model.getExercisesForWorkout(workout.id!);

    await model.deleteWorkout(workout);

    if (!context.mounted) return;

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('${workout.title} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await model.restoreWorkoutWithExercises(
              workout,
              savedExercises,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.workouts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No workouts yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the Add tab to create a workout plan for leg day, push day, pull day, or a custom routine.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: model.workouts.length,
          itemBuilder: (context, index) {
            final workout = model.workouts[index];

            return Slidable(
              key: ValueKey(workout.id ?? workout.title),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.28,
                children: [
                  SlidableAction(
                    onPressed: (_) => _deleteWorkout(context, model, workout),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
              child: Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(18),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.green.shade800,
                    ),
                  ),
                  title: Text(
                    workout.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${workout.focusArea}\n${workout.notes}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDetailScreen(workout: workout),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}