import 'package:flutter/material.dart';
import '../services/apod_api_service.dart';
import '../models/apod_data.dart';

class APODScreen extends StatelessWidget {
  const APODScreen({super.key});

  Future<ApodData> _fetchApod() {
    return ApodApiService().fetchApodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmic Canvas'),
        centerTitle: true,
      ),
      body: FutureBuilder<ApodData>(
        future: _fetchApod(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final apod = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (apod.mediaType == 'image')
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 400, // Adjust as needed for your layout
                          child: Image.network(
                            apod.url,
                            fit: BoxFit.contain, // Show the full image
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image, size: 64)),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: Text(
                        'Video: ${apod.url}',
                        style: const TextStyle(color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    apod.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    apod.date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(apod.explanation),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}