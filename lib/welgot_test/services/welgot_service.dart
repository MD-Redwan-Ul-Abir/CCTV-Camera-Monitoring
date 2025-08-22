import 'dart:convert';
import 'package:http/http.dart' as http;

class WelgotService {
  static const String _apiKey = 'wg_2eff789aedd6e4dfc8bd2f1f722feea46';
  static const String _baseUrl = 'https://api.weglot.com/translate';

  static Future<String> translateText(String text, {String from = 'en', String to = 'bn'}) async {
    try {
      final url = '$_baseUrl?api_key=$_apiKey';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'l_from': from,
          'l_to': to,
          'request_url': 'https://example.com/',
          'words': [
            {'w': text, 't': 1}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final toWords = data['to_words'] as List?;
        if (toWords != null && toWords.isNotEmpty) {
          return toWords[0] ?? text;
        }
        return text;
      } else {
        print('Translation failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return text; // Return original text on failure
      }
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text on error
    }
  }

  static Future<bool> testConnection() async {
    try {
      final testText = "Hello";
      final result = await translateText(testText);
      return result != testText; // If translation happened, connection is working
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}