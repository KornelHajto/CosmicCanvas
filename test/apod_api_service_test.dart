import 'package:flutter_test/flutter_test.dart';
import 'package:cosmiccanvas/services/apod_api_service.dart';
import 'package:cosmiccanvas/models/apod_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ApodApiService', () {
    test('fetchApodData returns ApodData for today (mocked)', () async {
      final mockResponse = jsonEncode({
        'date': '2025-06-28',
        'title': 'Test Title',
        'explanation': 'Test explanation',
        'url': 'https://example.com/image.jpg',
        'media_type': 'image',
      });
      final mockClient = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });
      final service = ApodApiService(client: mockClient);
      final data = await service.fetchApodData();
      expect(data, isA<ApodData>());
      expect(data.title, 'Test Title');
    });

    test('fetchApodData throws for invalid date (mocked error)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      final service = ApodApiService(client: mockClient);
      expect(
        () async => await service.fetchApodData(date: '1900-01-01'),
        throwsException,
      );
    });
  });
}
