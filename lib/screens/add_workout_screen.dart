import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../app_model.dart';
import '../models/workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _focusAreaController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _focusAreaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppModel model) async {
    if (!_formKey.currentState!.validate()) return;

    await model.addWorkout(
      Workout(
        title: _titleController.text.trim(),
        focusArea: _focusAreaController.text.trim(),
        notes: _notesController.text.trim(),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout saved to database')),
    );

    _titleController.clear();
    _focusAreaController.clear();
    _notesController.clear();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade700,
                        Colors.green.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Build a workout plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Create routines for clients, athletes, or personal training days.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration(
                    'Workout Title',
                    Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a workout title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _focusAreaController,
                  decoration: _inputDecoration(
                    'Target Area',
                    Icons.accessibility_new,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a target area';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: _inputDecoration(
                    'Notes',
                    Icons.notes,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter workout notes';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _submit(model),
                    icon: const Icon(Icons.save),
                    label: const Text('Save Workout'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}