import 'dart:convert';
import 'dart:io';

class ChefApiResponse {
  final String reply;
  final String? suggestedAction;
  final String? matchedRecipeId;
  final String disclaimer;
  final bool isFromBackend;

  const ChefApiResponse({
    required this.reply,
    this.suggestedAction,
    this.matchedRecipeId,
    required this.disclaimer,
    required this.isFromBackend,
  });
}

class ChefApiClient {
  final String baseUrl;

  ChefApiClient({String? baseUrl})
      : baseUrl = baseUrl ??
            (Platform.isAndroid
                ? 'http://10.0.2.2:8000'
                : 'http://127.0.0.1:8000');

  Future<ChefApiResponse?> queryBackend({
    required String query,
    required List<Map<String, dynamic>> inventory,
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(milliseconds: 600);

      final uri = Uri.parse('$baseUrl/v1/chef/respond');
      final request = await client
          .postUrl(uri)
          .timeout(const Duration(milliseconds: 600));
      request.headers.contentType = ContentType.json;

      final payload = jsonEncode({
        'query': query,
        'inventory': inventory,
      });

      request.write(payload);
      final response =
          await request.close().timeout(const Duration(milliseconds: 800));

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseBody) as Map<String, dynamic>;

        return ChefApiResponse(
          reply: json['reply'] as String,
          suggestedAction: json['suggested_action'] as String?,
          matchedRecipeId: json['matched_recipe_id'] as String?,
          disclaimer: json['disclaimer'] as String? ??
              'Gıda Güvenliği: Öneriler bilgilendirme amaçlıdır.',
          isFromBackend: true,
        );
      }
      return null;
    } catch (_) {
      // Offline fallback: return null immediately to trigger rich local assistant logic
      return null;
    }
  }
}
