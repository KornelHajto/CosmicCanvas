import 'dart:convert';
import 'package:http/http.dart' as http;

class ApodApiService {
  static const String _baseUrl = 'https://api.nasa.gov/planetary/apod';
  //TODO: Replace with actual API Key
  static const String _apiKey = 'DEMO_KEY';

  Future<Map<String, dynamic>> fetchApodData({String? date}) async {
    final String url = '$_baseUrl?api_key=$_apiKey${date != null ? '&date=$date' : ''}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('APOD data fetched successfully: ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load APOD data');
    }
  }
}