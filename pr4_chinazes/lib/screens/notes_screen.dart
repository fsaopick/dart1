import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:notes_app/bloc/theme_bloc.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/widgets/note_card.dart';
import 'package:notes_app/widgets/note_editor.dart';
import 'package:notes_app/widgets/search_field.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeChanged(!state.isDark));
                },
              );
            },
          ),
        ],
      ),
      body: const _NotesBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  static void _showNoteEditor(BuildContext context, {Note? note}) {
    showDialog(
      context: context,
      builder: (context) => NoteEditor(
        note: note,
        onSave: (updatedNote) {
          if (note == null) {
            context.read<NotesBloc>().add(NoteAdded(updatedNote));
          } else {
            context.read<NotesBloc>().add(NoteUpdated(updatedNote));
          }
        },
        onDelete: note != null 
            ? (id) => context.read<NotesBloc>().add(NoteDeleted(id))
            : null,
      ),
    );
  }
}

class _NotesBody extends StatelessWidget {
  const _NotesBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchField(
            onChanged: (query) {
              context.read<NotesBloc>().add(NotesSearched(query));
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state.filteredNotes.isEmpty) {
                  return Center(
                    child: Text(
                      state.searchQuery.isEmpty 
                          ? 'Нет заметок\nНажмите + чтобы добавить'
                          : 'Заметки не найдены',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = state.filteredNotes[index];
                    return NoteCard(
                      note: note,
                      onTap: () => NotesScreen._showNoteEditor(context, note: note),
                      onDelete: () {
                        context.read<NotesBloc>().add(NoteDeleted(note.id));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}