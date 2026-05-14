import 'package:scoped_model/scoped_model.dart';
import 'database_worker.dart';
import 'models/workout.dart';
import 'models/exercise.dart';

class AppModel extends Model {
  final List<Workout> _workouts = [];
  bool _isLoading = false;

  List<Workout> get workouts => List.unmodifiable(_workouts);
  bool get isLoading => _isLoading;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    final loadedWorkouts = await DatabaseWorker.instance.readAllWorkouts();

    _workouts
      ..clear()
      ..addAll(loadedWorkouts);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await DatabaseWorker.instance.createWorkout(workout);
    await loadWorkouts();
  }

  Future<Workout> addWorkoutAndReturn(Workout workout) async {
    final savedWorkout = await DatabaseWorker.instance.createWorkout(workout);
    await loadWorkouts();
    return savedWorkout;
  }

  Future<void> addDiscoveredExerciseAsWorkout({
    required String workoutTitle,
    required String focusArea,
    required String notes,
    required String exerciseName,
    required String targetArea,
    required String equipment,
    required String instructions,
  }) async {
    final savedWorkout = await DatabaseWorker.instance.createWorkout(
      Workout(
        title: workoutTitle,
        focusArea: focusArea,
        notes: notes,
      ),
    );

    await DatabaseWorker.instance.createExercise(
      Exercise(
        workoutId: savedWorkout.id!,
        name: exerciseName,
        targetArea: targetArea,
        equipment: equipment,
        instructions: instructions,
      ),
    );

    await loadWorkouts();
  }

  Future<List<Exercise>> getExercisesForWorkout(int workoutId) {
    return DatabaseWorker.instance.readExercisesForWorkout(workoutId);
  }

  Future<void> addExercise(Exercise exercise) async {
    await DatabaseWorker.instance.createExercise(exercise);
    notifyListeners();
  }

  Future<void> deleteExercise(Exercise exercise) async {
    if (exercise.id == null) return;

    await DatabaseWorker.instance.deleteExercise(exercise.id!);
    notifyListeners();
  }

  Future<void> deleteWorkout(Workout workout) async {
    if (workout.id == null) return;

    await DatabaseWorker.instance.deleteWorkout(workout.id!);
    await loadWorkouts();
  }

  Future<void> restoreWorkout(Workout workout) async {
    await DatabaseWorker.instance.createWorkout(
      Workout(
        title: workout.title,
        focusArea: workout.focusArea,
        notes: workout.notes,
      ),
    );

    await loadWorkouts();
  }

  Future<void> restoreWorkoutWithExercises(
      Workout workout,
      List<Exercise> exercises,
      ) async {
    final restoredWorkout = await DatabaseWorker.instance.createWorkout(
      Workout(
        title: workout.title,
        focusArea: workout.focusArea,
        notes: workout.notes,
      ),
    );

    for (final exercise in exercises) {
      await DatabaseWorker.instance.createExercise(
        Exercise(
          workoutId: restoredWorkout.id!,
          name: exercise.name,
          targetArea: exercise.targetArea,
          equipment: exercise.equipment,
          instructions: exercise.instructions,
        ),
      );
    }

    await loadWorkouts();
  }
}