import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;
  final Function(String)? onDelete;

  const NoteEditor({
    super.key,
    this.note,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _controller;
  CardStyle _selectedStyle = CardStyle.blue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.content ?? '');
    _selectedStyle = widget.note?.style ?? CardStyle.blue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Новая заметка' : 'Редактировать заметку'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Введите текст заметки...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildStyleSelector(),
        ],
      ),
      actions: [
        if (widget.note != null && widget.onDelete != null)
          TextButton(
            onPressed: () {
              widget.onDelete!(widget.note!.id);
              Navigator.of(context).pop();
            },
            child: Text(
              'Удалить',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Стиль карточки:',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: CardStyle.values.map((style) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => setState(() => _selectedStyle = style),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStyleColor(style),
                      borderRadius: BorderRadius.circular(8),
                      border: _selectedStyle == style
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStyleColor(CardStyle style) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (style) {
      case CardStyle.blue:
        return colorScheme.primaryContainer;
      case CardStyle.green:
        return colorScheme.secondaryContainer;
      case CardStyle.purple:
        return colorScheme.tertiaryContainer;
      case CardStyle.orange:
        return colorScheme.errorContainer;
    }
  }

  void _saveNote() {
    if (_controller.text.trim().isNotEmpty) {
      final note = Note(
        id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: _controller.text.trim(),
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        style: _selectedStyle,
      );
      widget.onSave(note);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}