class Issue {
  final String id;
  final String title;
  final String description;
  final String status;
  final int priority;
  final String issueType;
  final String owner;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final List<String> dependencies;
  final int dependencyCount;
  final int commentCount;

  const Issue({
    required this.id,
    required this.title,
    this.description = '',
    this.status = 'open',
    this.priority = 2,
    this.issueType = 'task',
    this.owner = '',
    required this.createdAt,
    this.createdBy = '',
    required this.updatedAt,
    this.dependencies = const [],
    this.dependencyCount = 0,
    this.commentCount = 0,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'open',
      priority: (json['priority'] as int?) ?? 2,
      issueType: (json['issue_type'] as String?) ?? 'task',
      owner: (json['owner'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: (json['created_by'] as String?) ?? '',
      updatedAt: DateTime.parse(json['updated_at'] as String),
      dependencies: (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dependencyCount: (json['dependency_count'] as int?) ?? 0,
      commentCount: (json['comment_count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'priority': priority,
        'issue_type': issueType,
        'owner': owner,
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
        'updated_at': updatedAt.toIso8601String(),
        'dependencies': dependencies,
        'dependency_count': dependencyCount,
        'comment_count': commentCount,
      };
}
