import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/workout.dart';
import 'models/exercise.dart';

class DatabaseWorker {
  static final DatabaseWorker instance = DatabaseWorker._internal();
  static Database? _database;

  DatabaseWorker._internal();

  Future<Database> get database async {
    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fittrainer_planner.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        focusArea TEXT NOT NULL,
        notes TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutId INTEGER NOT NULL,
        name TEXT NOT NULL,
        targetArea TEXT NOT NULL,
        equipment TEXT NOT NULL,
        instructions TEXT NOT NULL,
        FOREIGN KEY (workoutId) REFERENCES workouts (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<Workout> createWorkout(Workout workout) async {
    final db = await database;
    final id = await db.insert('workouts', workout.toMap());
    return workout.copyWith(id: id);
  }

  Future<List<Workout>> readAllWorkouts() async {
    final db = await database;

    final maps = await db.query(
      'workouts',
      orderBy: 'id DESC',
    );

    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<int> deleteWorkout(int id) async {
    final db = await database;

    await db.delete(
      'exercises',
      where: 'workoutId = ?',
      whereArgs: [id],
    );

    return db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await database;
    final id = await db.insert('exercises', exercise.toMap());
    return exercise.copyWith(id: id);
  }

  Future<List<Exercise>> readExercisesForWorkout(int workoutId) async {
    final db = await database;

    final maps = await db.query(
      'exercises',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
      orderBy: 'id DESC',
    );

    return maps.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<int> deleteExercise(int id) async {
    final db = await database;

    return db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}