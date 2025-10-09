import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/models/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState(notes: [], filteredNotes: [])) {
    on<NotesLoaded>(_onNotesLoaded);
    on<NoteAdded>(_onNoteAdded);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
    on<NotesSearched>(_onNotesSearched);
  }

  void _onNotesLoaded(NotesLoaded event, Emitter<NotesState> emit) {
    emit(state.copyWith(
      notes: [],
      filteredNotes: [],
      isLoading: false,
    ));
  }

  void _onNoteAdded(NoteAdded event, Emitter<NotesState> emit) {
    final newNotes = List<Note>.from(state.notes)..add(event.note);
    final filteredNotes = _filterNotes(newNotes, state.searchQuery);
    
    emit(state.copyWith(
      notes: newNotes,
      filteredNotes: filteredNotes,
    ));
  }

  void _onNoteUpdated(NoteUpdated event, Emitter<NotesState> emit) {
    final newNotes = state.notes.map((note) => 
      note.id == event.note.id ? event.note : note
    ).toList();
    final filteredNotes = _filterNotes(newNotes, state.searchQuery);
    
    emit(state.copyWith(
      notes: newNotes,
      filteredNotes: filteredNotes,
    ));
  }

  void _onNoteDeleted(NoteDeleted event, Emitter<NotesState> emit) {
    final newNotes = state.notes.where((note) => note.id != event.id).toList();
    final filteredNotes = _filterNotes(newNotes, state.searchQuery);
    
    emit(state.copyWith(
      notes: newNotes,
      filteredNotes: filteredNotes,
    ));
  }

  void _onNotesSearched(NotesSearched event, Emitter<NotesState> emit) {
    final filteredNotes = _filterNotes(state.notes, event.query);
    
    emit(state.copyWith(
      filteredNotes: filteredNotes,
      searchQuery: event.query,
    ));
  }

  List<Note> _filterNotes(List<Note> notes, String query) {
    if (query.isEmpty) return notes;
    
    return notes.where((note) => 
      note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}