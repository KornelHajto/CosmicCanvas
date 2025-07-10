import 'package:flutter/material.dart';
import '../services/share_service.dart';
import '../models/apod_data.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final ApodData? apod;
  
  const FullScreenImageViewer({
    super.key, 
    required this.imageUrl, 
    required this.tag,
    this.apod,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: tag,
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white, size: 100),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              if (apod != null)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    child: const Icon(Icons.share, color: Colors.white),
                    onPressed: () => ShareService().shareApod(apod!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
