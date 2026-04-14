import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Swap',
      theme: ThemeData(
        primaryColor: Color(0xFF44ACFF),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF44ACFF),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF44ACFF),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}