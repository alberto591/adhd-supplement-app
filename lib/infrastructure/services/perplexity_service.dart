import 'dart:convert';
import 'package:http/http.dart' as http;

class PerplexityService {
  final String apiKey;
  final String baseUrl = 'https://api.perplexity.ai/chat/completions';

  // In a real production app, use an environment variable or secure config.
  // For this private request, we use the key provided by the user.
  static const String _defaultApiKey =
      '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';

  PerplexityService({String? apiKey}) : apiKey = apiKey ?? _defaultApiKey;

  Future<String> search(String query) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar-reasoning-pro', // Using a high-quality model
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant for an ADHD supplement app. Provide concise, evidence-based information about supplements. Focus on safety, interactions, and benefits for ADHD.'
            },
            {'role': 'user', 'content': query}
          ],
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Perplexity API Error: $e');
    }
  }
}
