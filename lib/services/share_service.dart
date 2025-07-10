import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/apod_data.dart';

class ShareService {
  /// Shares the APOD with image (if available) and formatted text
  Future<void> shareApod(ApodData apod) async {
    // For non-image media types, just share text
    if (apod.mediaType != 'image') {
      await _shareText(apod);
      return;
    }

    try {
      // Use HD URL if available, otherwise use regular URL
      final imageUrl = apod.hdUrl ?? apod.url;
      
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      
      // Get temporary directory to save the image
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/apod_${apod.date.replaceAll('-', '')}.jpg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.bodyBytes);
      
      // Create the caption text
      final String text = '''
${apod.title} - NASA Astronomy Picture of the Day
Date: ${apod.date}
${apod.copyright != null ? '© ${apod.copyright}' : ''}

Shared from CosmicCanvas app
''';
      
      // Share both the image and text
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: text,
        subject: '${apod.title} - NASA APOD'
      );
    } catch (e) {
      // Fallback to text sharing if image sharing fails
      await _shareText(apod);
    }
  }
  
  Future<void> _shareText(ApodData apod) async {
    final String text = '''
${apod.title} - NASA Astronomy Picture of the Day
Date: ${apod.date}
${apod.copyright != null ? '© ${apod.copyright}' : ''}

${apod.explanation.length > 200 ? '${apod.explanation.substring(0, 200)}...' : apod.explanation}

View in CosmicCanvas app or at: https://apod.nasa.gov/apod/ap${apod.date.replaceAll('-', '').substring(2)}.html
''';

    await Share.share(text, subject: '${apod.title} - NASA APOD');
  }
}
