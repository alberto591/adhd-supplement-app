import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/logger.dart';

class PerplexityService {
  final String apiKey;
  final http.Client _client;
  final String baseUrl = 'https://api.perplexity.ai/chat/completions';

  static const String _defaultApiKey =
      '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';

  PerplexityService({String? apiKey, http.Client? client})
      : apiKey = apiKey ?? _defaultApiKey,
        _client = client ?? http.Client();

  static const String chemistSystemPrompt =
      'You are "Alchemist", a bio-optimization specialist specialized in neuro-chemistry. '
      'You provide deep-dive scientific explanations for Neurostack supplements. '
      'Focus on: molecular mechanisms of action, bioavailability, blood-brain barrier penetration, and chemical stability. '
      'Use technical but accessible language. Always cite theoretical routine optimizations and metabolic pathways.';

  Future<String> search(String query, {String? systemPrompt}) async {
    try {
      final response = await _client.post(
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
              'content': systemPrompt ??
                  'You are a helpful assistant for an Neurostack supplement app. Provide concise, evidence-based information about supplements. Focus on safety, compatibilitys, and benefits for Neurostack.'
            },
            {'role': 'user', 'content': query}
          ],
          'max_tokens': 4000,
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

  Future<Map<String, dynamic>> generateDailyArticle() async {
    const systemPrompt = '''
You are an expert researcher and general editor for a focus optimization app.
Generate a high-quality, engaging, and scientifically accurate daily article about a specific supplement, habit, or neuroscience concept relevant to Neurostack.
The output MUST be a valid JSON object with the following fields:
- "title": Catchy but accurate title.
- "tldr": A 1-sentence summary.
- "content": A 3-paragaph markdown string. Use headers like ## Mechanism.
- "readTime": e.g. "3 min read".
- "category": One of: "SCIENCE", "FOCUS", "STACKS", "LIFESTYLE".
- "author": "AI-chemist" or a relevant persona.
- "authorRole": "AI Research Assistant".
- "imageUrl": "https://images.unsplash.com/photo-1557683316-973673baf926?auto=format&fit=crop&q=80&w=1600" // Fallback gradient/abstract
- "authorAvatarUrl": "https://i.pravatar.cc/100?img=11"

Do not include markdown code blocks (like ```json) in the response, just the raw JSON.
''';

    final prompt =
        'Generate the daily article for ${DateTime.now().toIso8601String()}. Focus on something different than standard Magnesium or Caffeine if possible, maybe a lesser known nootropic or behavioral protocol.';

    try {
      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar-reasoning-pro',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        // Clean up markdown code blocks if present
        final cleanJson =
            content.replaceAll('```json', '').replaceAll('```', '').trim();

        try {
          return jsonDecode(cleanJson) as Map<String, dynamic>;
        } catch (e) {
          throw Exception('Failed to parse AI response as JSON: $content');
        }
      } else {
        throw Exception(
            'Failed to load daily article: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Perplexity API Error: $e');
    }
  }

  Future<List<Map<String, String>>> getPersonalizedRecommendations({
    required List<String> goals,
    List<String> currentStack = const [],
  }) async {
    const systemPrompt = '''
You are a senior neuro-chemist and supplement advisor.
Analyze the user's goals and current stack to provide the TOP 3 most effective supplement recommendations.
You must ensure safety and synergy.
Output strictly JSON in this format:
[
  {
    "name": "Exact Supplement Name",
    "reason": "1-sentence specific explanation linking biochemistry to their specific goal."
  }
]
Do not include markdown formatting like ```json.
''';

    final prompt =
        'User Goals: ${goals.join(", ")}. Current Stack: ${currentStack.join(", ")}. What are the best 3 additions?';

    try {
      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar-reasoning-pro',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt}
          ],
          // Reasoning models need more tokens for chain-of-thought
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        // Robust JSON extraction using Regex to find the array
        String cleanJson = content.trim();

        // Try to find a JSON array pattern [ ... ]
        final jsonPattern = RegExp(r'\[.*\]', dotAll: true);
        final match = jsonPattern.firstMatch(cleanJson);

        if (match != null) {
          cleanJson = match.group(0)!;
        } else {
          // Fallback cleanup
          cleanJson =
              cleanJson.replaceAll('```json', '').replaceAll('```', '').trim();
        }

        try {
          final List<dynamic> parsed = jsonDecode(cleanJson) as List<dynamic>;
          return parsed
              .map((item) => {
                    'name': item['name'].toString(),
                    'reason': item['reason'].toString(),
                  })
              .toList();
        } catch (e) {
          // Log the raw content for debugging
          AppLogger.e('AI JSON Parse Error: $e');
          AppLogger.d('Raw Content: $content');
          throw Exception('Failed to decode AI JSON. Content: $content');
        }
      } else {
        throw Exception(
            'Failed to fetch recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Perplexity Recommendations Error: $e');
    }
  }
}
