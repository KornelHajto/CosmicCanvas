import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/apod_api_service.dart';
import '../models/apod_data.dart';
import 'settings_screen.dart';
import '../services/settings_service.dart';
import '../services/favourites_service.dart';
import '../services/share_service.dart';
import 'full_screen_image_viewer.dart';

class APODScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final double fontSizeFactor;
  final ValueChanged<double> onFontSizeChanged;
  final bool defaultToToday;
  final ValueChanged<bool> onDefaultToTodayChanged;
  final bool showCopyright;
  final ValueChanged<bool> onShowCopyrightChanged;
  final bool showDescription;
  final ValueChanged<bool> onShowDescriptionChanged;
  const APODScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.fontSizeFactor,
    required this.onFontSizeChanged,
    required this.defaultToToday,
    required this.onDefaultToTodayChanged,
    required this.showCopyright,
    required this.onShowCopyrightChanged,
    required this.showDescription,
    required this.onShowDescriptionChanged,
  });

  @override
  State<APODScreen> createState() => _APODScreenState();
}

class _APODScreenState extends State<APODScreen> {
  late Future<ApodData> _apodFuture;
  String? _selectedDate;
  bool _useHd = false;
  bool _defaultToToday = true;
  bool _showCopyright = true;
  bool _showDescription = true;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _defaultToToday = widget.defaultToToday;
    _showCopyright = widget.showCopyright;
    _showDescription = widget.showDescription;
    _loadInitialDate();
  }

  Future<void> _loadInitialDate() async {
    final settings = SettingsService();
    if (_defaultToToday) {
      setState(() {
        _selectedDate = null;
        _apodFuture = ApodApiService().fetchApodData();
      });
    } else {
      final lastViewed = await settings.getLastViewedDate();
      setState(() {
        _selectedDate = lastViewed;
        _apodFuture = ApodApiService().fetchApodData(date: lastViewed);
      });
    }
    _checkFavourite();
  }

  Future<void> _checkFavourite() async {
    final date = _selectedDate ?? DateTime.now().toIso8601String().split('T').first;
    final fav = await FavouritesService().isFavourite(date);
    setState(() {
      _isFavourite = fav;
    });
  }

  Future<void> _toggleFavourite(ApodData apod) async {
    final service = FavouritesService();
    if (_isFavourite) {
      await service.removeFavourite(apod.date);
      setState(() => _isFavourite = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from favourites')));
    } else {
      await service.addFavourite(apod);
      setState(() => _isFavourite = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to favourites')));
    }
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
      final dateStr = picked.toIso8601String().split('T').first;
      setState(() {
        _selectedDate = dateStr;
        _apodFuture = ApodApiService().fetchApodData(date: dateStr);
      });
      await SettingsService().setLastViewedDate(dateStr);
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
          themeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
          fontSizeFactor: widget.fontSizeFactor,
          onFontSizeChanged: widget.onFontSizeChanged,
          defaultToToday: _defaultToToday,
          onDefaultToTodayChanged: (value) async {
            setState(() {
              _defaultToToday = value;
            });
            await SettingsService().setDefaultToToday(value);
            widget.onDefaultToTodayChanged(value);
            Navigator.pop(context);
            _loadInitialDate();
          },
          showCopyright: _showCopyright,
          onShowCopyrightChanged: (value) async {
            setState(() {
              _showCopyright = value;
            });
            widget.onShowCopyrightChanged(value);
            Navigator.pop(context);
          },
          showDescription: _showDescription,
          onShowDescriptionChanged: (value) async {
            setState(() {
              _showDescription = value;
            });
            widget.onShowDescriptionChanged(value);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _retryLoad() {
    setState(() {
      _apodFuture = _selectedDate != null
          ? ApodApiService().fetchApodData(date: _selectedDate)
          : ApodApiService().fetchApodData();
    });
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Container(
                      height: 32,
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Container(
                      height: 20,
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Container(
                      height: 80,
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load APOD.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () {
                      _retryLoad();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Retrying...')),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final apod = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) => _checkFavourite());
            final imageUrl = (_useHd && apod.hdUrl != null) ? apod.hdUrl! : apod.url;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (apod.mediaType == 'image')
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImageViewer(
                                imageUrl: imageUrl,
                                tag: 'apod-image',
                                apod: apod,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'apod-image',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 400,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          apod.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize! * widget.fontSizeFactor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isFavourite ? Icons.star : Icons.star_border),
                        color: Theme.of(context).colorScheme.secondary,
                        tooltip: _isFavourite ? 'Remove from favourites' : 'Add to favourites',
                        onPressed: () => _toggleFavourite(apod),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Share this APOD',
                        onPressed: () => ShareService().shareApod(apod),
                      ),
                    ],
                  ),
                  if (_showCopyright && apod.copyright != null)
                    Text(
                      '© ${apod.copyright}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! * widget.fontSizeFactor,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[400],
                      ),
                    ),
                  Text(
                    apod.date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! * widget.fontSizeFactor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: Text(
                      'Explanation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * widget.fontSizeFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: _showDescription,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          apod.explanation,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * widget.fontSizeFactor,
                          ),
                        ),
                      ),
                    ],
                  ),
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