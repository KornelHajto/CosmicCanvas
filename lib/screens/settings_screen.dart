import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool useHd;
  final ValueChanged<bool> onQualityChanged;

  const SettingsScreen({
    super.key,
    required this.useHd,
    required this.onQualityChanged,
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
        ],
      ),
    );
  }
}