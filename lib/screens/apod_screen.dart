import 'package:flutter/material.dart';
import '../services/apod_api_service.dart';
import '../models/apod_data.dart';
import 'settings_screen.dart';

class APODScreen extends StatefulWidget {
  const APODScreen({super.key});

  @override
  State<APODScreen> createState() => _APODScreenState();
}

class _APODScreenState extends State<APODScreen> {
  late Future<ApodData> _apodFuture;
  String? _selectedDate;
  bool _useHd = false;

  @override
  void initState() {
    super.initState();
    _apodFuture = ApodApiService().fetchApodData();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null
          ? DateTime.parse(_selectedDate!)
          : DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.toIso8601String().split('T').first;
        _apodFuture = ApodApiService().fetchApodData(date: _selectedDate);
      });
    }
  }

  void _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          useHd: _useHd,
          onQualityChanged: (value) {
            setState(() {
              _useHd = value;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_today),
          tooltip: 'Pick a date',
          onPressed: _pickDate,
        ),
        title: const Text('Cosmic Canvas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: FutureBuilder<ApodData>(
        future: _apodFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error:  ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final apod = snapshot.data!;
            final imageUrl = (_useHd && apod.hdUrl != null) ? apod.hdUrl! : apod.url;
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
                          height: 400,
                          child: Hero(
                            tag: 'apod-image',
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image, size: 64)),
                            ),
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
                        'Video:  ${apod.url}',
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