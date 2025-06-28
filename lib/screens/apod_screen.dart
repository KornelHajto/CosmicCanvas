import 'package:flutter/material.dart';

class APODScreen extends StatelessWidget {
  const APODScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmic Canvas'),
        centerTitle: true,
      ),
      body: Center(child: Text('APOD Screen'),),
    );
  }
}