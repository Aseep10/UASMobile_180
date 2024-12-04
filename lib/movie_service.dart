import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchMovies(String query, int page) async {
  try {
    final url =
        'https://www.omdbapi.com/?apikey=399bf92&s=${query.isEmpty ? "movie" : query}&page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return data['Search'] ?? [];
      } else {
        throw Exception(data['Error'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to fetch movies: ${response.statusCode}');
    }
  } catch (e) {
    print("Error in fetchMovies: $e");
    return [];
  }
}


