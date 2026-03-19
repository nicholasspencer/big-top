class Comment {
  final String id;
  final String issueId;
  final String author;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.issueId,
    this.author = '',
    this.content = '',
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      issueId: json['issue_id'] as String,
      author: (json['author'] as String?) ?? '',
      content: (json['content'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'issue_id': issueId,
        'author': author,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };
}
