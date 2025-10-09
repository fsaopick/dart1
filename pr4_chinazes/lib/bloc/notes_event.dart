part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesLoaded extends NotesEvent {}

class NoteAdded extends NotesEvent {
  final Note note;

  const NoteAdded(this.note);

  @override
  List<Object> get props => [note];
}

class NoteUpdated extends NotesEvent {
  final Note note;

  const NoteUpdated(this.note);

  @override
  List<Object> get props => [note];
}

class NoteDeleted extends NotesEvent {
  final String id;

  const NoteDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class NotesSearched extends NotesEvent {
  final String query;

  const NotesSearched(this.query);

  @override
  List<Object> get props => [query];
}