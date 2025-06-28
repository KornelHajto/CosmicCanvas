import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      appBar: AppBar(title: const Text('About')),
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
            const Text('Your Name or Team'),
            const Text('your@email.com'),
            const SizedBox(height: 24),
            const Text('This app is not affiliated with NASA.'),
          ],
        ),
      ),
    );
  }
}
