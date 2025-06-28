import 'package:flutter/material.dart';
import '../services/favourites_service.dart';
import '../models/apod_data.dart';
import '../services/apod_api_service.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<ApodData>> _favouritesFuture;

  @override
  void initState() {
    super.initState();
    _favouritesFuture = FavouritesService().getFavourites();
  }

  Future<void> _removeFavourite(String date) async {
    await FavouritesService().removeFavourite(date);
    setState(() {
      _favouritesFuture = FavouritesService().getFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: FutureBuilder<List<ApodData>>(
        future: _favouritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading favourites'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final favourites = snapshot.data!;
            return ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, idx) {
                final apod = favourites[idx];
                return ListTile(
                  leading: apod.mediaType == 'image'
                      ? Image.network(apod.url, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                      : const Icon(Icons.image),
                  title: Text(apod.title),
                  subtitle: Text(apod.date),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFavourite(apod.date),
                  ),
                  onTap: () async {
                    // Optionally, show APOD details here or navigate back to main screen with this date
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No favourites yet.'));
          }
        },
      ),
    );
  }
}
