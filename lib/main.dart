import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'app_model.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppModel model = AppModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitTrainer Planner',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
          ),
        ),
        home: FutureBuilder<void>(
          future: model.loadWorkouts(),
          builder: (context, snapshot) {
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}