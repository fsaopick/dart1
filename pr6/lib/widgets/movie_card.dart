import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_list_app/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: movie.imagePath != null
                ? Image.file(
                    File(movie.imagePath!),
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.movie, size: 50),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${movie.year} • ${movie.genre}'),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: EdgeInsets.zero,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}