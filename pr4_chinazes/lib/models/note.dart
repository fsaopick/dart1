class Note {
  final String id;
  final String content;
  final DateTime createdAt;
  final CardStyle style;

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    this.style = CardStyle.blue,
  });

  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    CardStyle? style,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      style: style ?? this.style,
    );
  }
}

enum CardStyle {
  blue,
  green,
  purple,
  orange,
}