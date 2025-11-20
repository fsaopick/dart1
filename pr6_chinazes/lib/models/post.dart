class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime date;
  final bool isRead;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'date': date.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
    );
  }

  Post copyWith({bool? isRead}) {
    return Post(
      id: id,
      title: title,
      content: content,
      author: author,
      date: date,
      isRead: isRead ?? this.isRead,
    );
  }
}