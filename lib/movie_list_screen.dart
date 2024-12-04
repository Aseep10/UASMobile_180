import 'package:flutter/material.dart';
import 'movie_service.dart';
import 'movie_detail_screen.dart';
import 'movie_search_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late List<dynamic> movieList;
  bool isLoading = false;
  int page = 1;
  final int moviesPerPage = 20;
  late ScrollController _scrollController;

  final List<String> genres = [
    "All",
    "Action",
    "Comedy",
    "Drama",
    "Horror",
    "Romance",
    "Sci-Fi",
    "Thriller"
  ];
  String selectedGenre = "All";

  @override
  void initState() {
    super.initState();
    movieList = [];
    _fetchMovies(page);
    _scrollController = ScrollController();
  }

  Future<void> _fetchMovies(int page) async {
    setState(() {
      isLoading = true;
    });
    try {
      final newMovies = await fetchMovies(selectedGenre.toLowerCase(), page);
      setState(() {
        movieList.addAll(newMovies);
      });
    } catch (e) {
      print("Error fetching movies: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Latar belakang biru
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Warna lebih gelap untuk AppBar
        title: const Text(
          "Movie+ Hotstar",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MovieSearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text(
              "Search",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: genres.map((genre) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGenre = genre;
                                movieList.clear();
                                page = 1;
                                _fetchMovies(page);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: selectedGenre == genre
                                      ? [Colors.orangeAccent, Colors.deepOrange]
                                      : [Colors.grey[700]!, Colors.grey[500]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(5.0), // Sudut lebih tajam
                                boxShadow: selectedGenre == genre
                                    ? [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.7),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        )
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    color: selectedGenre == genre
                                        ? Colors.white
                                        : Colors.grey[300],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Favorite Movies",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Divider after "Favorite Movies"
                  const Divider(
                    color: Colors.white, // Divider color
                    thickness: 1.5, // Divider thickness
                    indent: 16.0, // Left indentation
                    endIndent: 16.0, // Right indentation
                  ),
                  // Horizontal movie list
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieList.length,
                      itemBuilder: (context, index) {
                        final movie = movieList[index];
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
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  movie['Poster'] ?? 'https://via.placeholder.com/140x200',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Recommended Movies",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Divider after "Recommended Movies"
                  const Divider(
                    color: Colors.white, // Divider color
                    thickness: 1.5, // Divider thickness
                    indent: 16.0, // Left indentation
                    endIndent: 16.0, // Right indentation
                  ),
                  // Vertical movie list with rating
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movieList.length,
                    itemBuilder: (context, index) {
                      final movie = movieList[index];
                      

                      final rating = movie['imdbRating'] != null
                          ? movie['imdbRating']
                          : 'N/A';

                      return ListTile(
                        leading: Image.network(
                          movie['Poster'] ?? 'https://via.placeholder.com/140x200',
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          movie['Title'] ?? 'No Title',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              movie['Year'] ?? 'No Year',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      );
                    },
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
