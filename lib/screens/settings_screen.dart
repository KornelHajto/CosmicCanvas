import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  final bool useHd;
  final ValueChanged<bool> onQualityChanged;
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

  const SettingsScreen({
    super.key,
    required this.useHd,
    required this.onQualityChanged,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Use HD Images'),
            subtitle: const Text('Show higher quality images when available'),
            value: useHd,
            onChanged: onQualityChanged,
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Choose app theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) onThemeModeChanged(mode);
              },
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: fontSizeFactor,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: fontSizeFactor.toStringAsFixed(2),
              onChanged: onFontSizeChanged,
            ),
          ),
          SwitchListTile(
            title: const Text('Default to Today'),
            subtitle: const Text('Always show today’s APOD on launch'),
            value: defaultToToday,
            onChanged: onDefaultToTodayChanged,
          ),
          SwitchListTile(
            title: const Text('Show Copyright'),
            subtitle: const Text('Display copyright info below the title'),
            value: showCopyright,
            onChanged: onShowCopyrightChanged,
          ),
          SwitchListTile(
            title: const Text('Show Description'),
            subtitle: const Text('Expand the explanation by default'),
            value: showDescription,
            onChanged: onShowDescriptionChanged,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About / Info'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _appName = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _appName = info.appName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About / Info')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_appName, style: Theme.of(context).textTheme.headlineSmall),
            Text('Version: $_version'),
            const SizedBox(height: 24),
            const Text('Credits', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('• Data: NASA Astronomy Picture of the Day (APOD) API'),
            const Text('• Built with Flutter'),
            const Text('• Open-source packages: http, shared_preferences, shimmer, package_info_plus'),
            const SizedBox(height: 24),
            const Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Kornél Hajtó'),
            const Text('kornelhajto2004@gmail.com'),
            const SizedBox(height: 24),
            const Text('This app is not affiliated with NASA.'),
          ],
        ),
      ),
    );
  }
}