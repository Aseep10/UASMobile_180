import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Map<String, dynamic> movieDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    final imdbID = widget.movie['imdbID']; // Ambil imdbID dari movie
    try {
      final response = await http
          .get(Uri.parse('https://www.omdbapi.com/?i=$imdbID&apikey=399bf92'));

      if (response.statusCode == 200) {
        setState(() {
          movieDetail = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch movie details');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Latar belakang biru gelap
      appBar: AppBar(
        title: Text(widget.movie['Title']),
        backgroundColor: Colors.blue[900], // Warna lebih gelap untuk AppBar
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster with shadow
                    if (movieDetail['Poster'] != 'N/A')
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              movieDetail['Poster'],
                              fit: BoxFit.cover,
                              width: 250, // Ukuran lebar gambar
                              height: 375, // Ukuran tinggi gambar
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Title Section with Typography Enhancement
                    Text(
                      movieDetail['Title'] ?? 'No Title Available',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5, // Spacing antara huruf
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Year and Genre with Divider
                    Row(
                      children: [
                        Text(
                          "Year: ${movieDetail['Year'] ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[300]!, // Memastikan nilai tidak null
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Genre: ${movieDetail['Genre'] ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[300]!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white, thickness: 1), // Divider

                    // Rating Section with Star Icon
                    if (movieDetail['imdbRating'] != 'N/A')
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          const SizedBox(width: 4),
                          Text(
                            "Rating: ${movieDetail['imdbRating'] ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Plot Section with Bold Title
                    const Text(
                      "Plot:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movieDetail['Plot'] ?? 'No description available.',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5, // Jarak antar baris
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider for separation
                    const Divider(color: Colors.white, thickness: 1),
                  ],
                ),
              ),
            ),
    );
  }
}
