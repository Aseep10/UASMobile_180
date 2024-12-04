import 'package:flutter/material.dart';
import 'movie_service.dart';
import 'movie_detail_screen.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> _searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final movies = await fetchMovies(query, 1);
      setState(() {
        searchResults = movies;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
      });
      print("Error searching movies: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Latar belakang biru
      appBar: AppBar(
        title: const Text('Search Movies'),
        backgroundColor: Colors.blue[900], // Warna lebih gelap untuk AppBar
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pencarian Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                hintStyle: TextStyle(color: Colors.grey[300]), // Warna hint text
                filled: true,
                fillColor: Colors.grey[700], // Latar belakang input field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Menghilangkan border
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _searchMovies(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan hasil pencarian
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? const Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final movie = searchResults[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movie: movie,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.grey[850], // Warna latar belakang card
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      movie['Poster'],
                                      width: 60,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    movie['Title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Year: ${movie['Year']}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
