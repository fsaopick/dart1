import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list_app/database/database_helper.dart';
import 'package:movie_list_app/models/movie.dart';

class AddEditMovieScreen extends StatefulWidget {
  final Movie? movie;

  const AddEditMovieScreen({super.key, this.movie});

  @override
  State<AddEditMovieScreen> createState() => _AddEditMovieScreenState();
}

class _AddEditMovieScreenState extends State<AddEditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late int _year;
  late String _genre;
  File? _image;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _title = widget.movie!.title;
      _year = widget.movie!.year;
      _genre = widget.movie!.genre;
    } else {
      _title = '';
      _year = DateTime.now().year;
      _genre = 'Drama';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : widget.movie?.imagePath != null
                          ? FileImage(File(widget.movie!.imagePath!))
                          : null,
                  child: _image == null && widget.movie?.imagePath == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _year.toString(),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1888 || year > DateTime.now().year + 5) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
                onSaved: (value) => _year = int.parse(value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _genre,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Drama', child: Text('Drama')),
                  DropdownMenuItem(value: 'Comedy', child: Text('Comedy')),
                  DropdownMenuItem(value: 'Action', child: Text('Action')),
                  DropdownMenuItem(value: 'Horror', child: Text('Horror')),
                  DropdownMenuItem(value: 'Sci-Fi', child: Text('Sci-Fi')),
                  DropdownMenuItem(value: 'Romance', child: Text('Romance')),
                ],
                onChanged: (value) => _genre = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final movie = Movie(
        id: widget.movie?.id,
        title: _title,
        year: _year,
        genre: _genre,
        imagePath: _image?.path ?? widget.movie?.imagePath,
      );

      if (widget.movie == null) {
        await _dbHelper.insertMovie(movie);
      } else {
        await _dbHelper.updateMovie(movie);
      }

      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}