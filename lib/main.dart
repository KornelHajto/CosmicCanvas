import 'package:flutter/material.dart';

void main() {
  runApp(const CosmicCanvasApp());
}

class CosmicCanvasApp extends StatelessWidget {
  const CosmicCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
      ),
      home: const HomeScreen(title: 'Cosmic Canvas'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontFamily: 'Raleway', fontSize: 24)),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Hi',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontFamily: 'Iosevka',
            fontSize: 32,
          ),
        ),
      )
    );
  }
}
