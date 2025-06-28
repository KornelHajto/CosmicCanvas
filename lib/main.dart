import 'package:flutter/material.dart';
import 'screens/apod_screen.dart';

void main() {
  runApp(const CosmicCanvasApp());
}

class CosmicCanvasApp extends StatelessWidget {
  const CosmicCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astronomy Picture of the Day',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Raleway',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Color(0xFFF9F6EE), // Bone white
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const APODScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}