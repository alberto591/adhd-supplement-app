import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:neurostack_app/infrastructure/services/perplexity_service.dart';

import 'perplexity_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late PerplexityService service;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    service = PerplexityService(client: mockClient);
  });

  group('PerplexityService - getPersonalizedRecommendations', () {
    test('successfully parses JSON response even with markdown blocks',
        () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  '```json\n[{"name": "Magnesium", "reason": "Supports sleep"}]\n```'
            }
          }
        ]
      });

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(mockResponse, 200));

      final results =
          await service.getPersonalizedRecommendations(goals: ['Sleep']);

      expect(results.length, 1);
      expect(results[0]['name'], 'Magnesium');
      expect(results[0]['reason'], 'Supports sleep');
    });

    test('throws exception on non-200 response', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => service.getPersonalizedRecommendations(goals: ['Focus']),
        throwsException,
      );
    });

    test('throws exception on invalid JSON content', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {'content': 'Invalid JSON'}
          }
        ]
      });

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(mockResponse, 200));

      expect(
        () => service.getPersonalizedRecommendations(goals: ['Energy']),
        throwsException,
      );
    });
  });
}
