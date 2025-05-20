import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesBloc()..add(LoadInitialNotes())),
      ],
      child: const MyApp(),
    ),
  );
}

// Events
abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialNotes extends NotesEvent {}

class ReorderNotes extends NotesEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderNotes(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final int id;

  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];
}

// States
class NotesState extends Equatable {
  final List<Note> notes;

  const NotesState(this.notes);

  @override
  List<Object> get props => [notes];
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState([])) {
    on<LoadInitialNotes>(_onLoadInitialNotes);
    on<ReorderNotes>(_onReorderNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  void _onLoadInitialNotes(LoadInitialNotes event, Emitter<NotesState> emit) {
    final notes = List.generate(
      10,
      (index) => Note(
        id: index,
        title: 'Заметка $index',
        content: 'Содержание заметки $index',
      ),
    );
    emit(NotesState(notes));
  }

  void _onReorderNotes(ReorderNotes event, Emitter<NotesState> emit) {
    final newIndex = event.newIndex;
    final oldIndex = event.oldIndex;
    final List<Note> updatedNotes = List.from(state.notes);
    
    if (oldIndex < newIndex) {
      final note = updatedNotes.removeAt(oldIndex);
      updatedNotes.insert(newIndex - 1, note);
    } else {
      final note = updatedNotes.removeAt(oldIndex);
      updatedNotes.insert(newIndex, note);
    }
    
    emit(NotesState(updatedNotes));
  }

  void _onAddNote(AddNote event, Emitter<NotesState> emit) {
    emit(NotesState([...state.notes, event.note]));
  }

  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) {
    final updatedNotes = state.notes.map((note) {
      return note.id == event.note.id ? event.note : note;
    }).toList();
    emit(NotesState(updatedNotes));
  }

  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) {
    emit(NotesState(
      state.notes.where((note) => note.id != event.id).toList(),
    ));
  }
}

class Note extends Equatable {
  final int id;
  final String title;
  final String content;

  const Note({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [id, title, content];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простые заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const NotesListScreen());
          case '/add':
            return MaterialPageRoute(builder: (_) => const AddNoteScreen());
          case '/edit':
            final note = settings.arguments as Note;
            return MaterialPageRoute(
              builder: (_) => EditNoteScreen(note: note),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Маршрут ${settings.name} не найден'),
                ),
              ),
            );
        }
      },
    );
  }
}

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        centerTitle: true,
      ),
      body: const NotesListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add'),
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите заголовок';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Содержание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        content: _contentController.text,
      );
      context.read<NotesBloc>().add(AddNote(note));
      Navigator.pop(context);
    }
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать заметку'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите заголовок';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Содержание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateNote() {
    if (_formKey.currentState!.validate()) {
      final updatedNote = Note(
        id: widget.note.id,
        title: _titleController.text,
        content: _contentController.text,
      );
      context.read<NotesBloc>().add(UpdateNote(updatedNote));
      Navigator.pop(context);
    }
  }
}

class NotesListView extends StatelessWidget {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.notes.length,
          onReorder: (oldIndex, newIndex) {
            context.read<NotesBloc>().add(ReorderNotes(oldIndex, newIndex));
          },
          itemBuilder: (context, index) {
            final note = state.notes[index];
            return Container(
              key: ValueKey(note.id),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/edit',
                        arguments: note,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, note.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<NotesBloc>().add(DeleteNote(id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заметка удалена')),
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}