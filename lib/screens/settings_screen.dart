import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}