import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/exercise_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luscinia',
      theme: ThemeData(
        primaryColor: const Color(0xFFF19C79),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFF19C79),
          secondary: const Color(0xFFCEE5D0),
          tertiary: const Color(0xFFFFF5E1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF19C79),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF19C79),
          elevation: 0,
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/exercise-list': (context) => const ExerciseListScreen(),
      },
    );
  }
}
