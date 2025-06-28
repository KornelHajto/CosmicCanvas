import 'package:flutter/material.dart';
import 'screens/apod_screen.dart';
import 'screens/favourites_screen.dart';
import 'services/settings_service.dart';

void main() {
  runApp(const CosmicCanvasApp());
}

class CosmicCanvasApp extends StatefulWidget {
  const CosmicCanvasApp({super.key});

  @override
  State<CosmicCanvasApp> createState() => _CosmicCanvasAppState();
}

class _CosmicCanvasAppState extends State<CosmicCanvasApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSizeFactor = 1.0;
  bool _defaultToToday = true;
  bool _showCopyright = true;
  bool _showDescription = true;

  @override
  void initState() {
    super.initState();
    _loadDefaultToToday();
    _loadShowCopyright();
    _loadShowDescription();
  }

  Future<void> _loadDefaultToToday() async {
    final value = await SettingsService().getDefaultToToday();
    setState(() {
      _defaultToToday = value;
    });
  }

  Future<void> _loadShowCopyright() async {
    final value = await SettingsService().getShowCopyright();
    setState(() {
      _showCopyright = value;
    });
  }

  Future<void> _loadShowDescription() async {
    final value = await SettingsService().getShowDescription();
    setState(() {
      _showDescription = value;
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _setFontSizeFactor(double factor) {
    setState(() {
      _fontSizeFactor = factor;
    });
  }

  void _setDefaultToToday(bool value) {
    setState(() {
      _defaultToToday = value;
    });
  }

  void _setShowCopyright(bool value) {
    setState(() {
      _showCopyright = value;
    });
    SettingsService().setShowCopyright(value);
  }

  void _setShowDescription(bool value) {
    setState(() {
      _showDescription = value;
    });
    SettingsService().setShowDescription(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astronomy Picture of the Day',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Raleway',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Raleway',
      ),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => APODScreen(
              themeMode: _themeMode,
              onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
              fontSizeFactor: _fontSizeFactor,
              onFontSizeChanged: (factor) => setState(() => _fontSizeFactor = factor),
              defaultToToday: _defaultToToday,
              onDefaultToTodayChanged: (val) => setState(() => _defaultToToday = val),
              showCopyright: _showCopyright,
              onShowCopyrightChanged: (val) => setState(() => _showCopyright = val),
              showDescription: _showDescription,
              onShowDescriptionChanged: (val) => setState(() => _showDescription = val),
            ),
        '/favourites': (context) => const FavouritesScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}