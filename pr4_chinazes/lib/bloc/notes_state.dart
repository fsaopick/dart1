part of 'notes_bloc.dart';

class NotesState extends Equatable {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final String searchQuery;
  final bool isLoading;

  const NotesState({
    required this.notes,
    required this.filteredNotes,
    this.searchQuery = '',
    this.isLoading = false,
  });

  NotesState copyWith({
    List<Note>? notes,
    List<Note>? filteredNotes,
    String? searchQuery,
    bool? isLoading,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [notes, filteredNotes, searchQuery, isLoading];
}