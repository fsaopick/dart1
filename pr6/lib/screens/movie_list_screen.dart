import 'package:flutter/material.dart';
import 'package:movie_list_app/database/database_helper.dart';
import 'package:movie_list_app/models/movie.dart';
import 'package:movie_list_app/screens/add_edit_movie_screen.dart';
import 'package:movie_list_app/screens/settings_screen.dart';
import 'package:movie_list_app/widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  Future<void> _refreshMovies() async {
    setState(() {
      _moviesFuture = _dbHelper.getAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies added yet'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return MovieCard(
                  movie: movie,
                  onDelete: () => _deleteMovie(movie.id!),
                  onEdit: () => _navigateToEditScreen(movie),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteMovie(int id) async {
    await _dbHelper.deleteMovie(id);
    _refreshMovies();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie deleted')),
    );
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditMovieScreen(),
      ),
    ).then((_) => _refreshMovies());
  }

  void _navigateToEditScreen(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMovieScreen(movie: movie),
      ),
    ).then((_) => _refreshMovies());
  }
}