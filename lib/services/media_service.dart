import 'package:http/http.dart' as http;
import 'dart:convert';

class MediaService {
  final String baseURL = 'http://192.168.178.80:3000/api';

  Future<List<dynamic>> searchMedia(String query) async {
    final String url = '$baseURL/media/search/$query';
    print('URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // TMDb gibt ein JSON mit 'results' zurück
      final results = data['results'] as List<dynamic>;
      print('Gefundene Ergebnisse: ${results.length}');

      return results;
    } else {
      throw Exception('Failed to search for media: $query');
    }
  }

  Future<void> saveRating(data) async {
    print(data);

    String url = '$baseURL/ratings/save-rating';

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      final res = jsonDecode(response.body);
      print('response @createList: $res');
      return res;
    } else {
      throw Exception('Failed to save rating');
    }
  }
}
