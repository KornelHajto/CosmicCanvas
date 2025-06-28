import 'package:flutter/material.dart';
import '../services/apod_api_service.dart';

class APODScreen extends StatelessWidget {
  const APODScreen({super.key});

  Future<Map<String, dynamic>> _fetchApod() {
    return ApodApiService().fetchApodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmic Canvas'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchApod(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Center(child: Text('Title: ${snapshot.data!['title']}'));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}