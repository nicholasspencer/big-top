class Dependency {
  final String issueId;
  final String dependsOnId;
  final String type;
  final DateTime createdAt;
  final String createdBy;
  final String metadata;

  const Dependency({
    required this.issueId,
    required this.dependsOnId,
    this.type = 'blocks',
    required this.createdAt,
    this.createdBy = '',
    this.metadata = '{}',
  });

  factory Dependency.fromJson(Map<String, dynamic> json) {
    return Dependency(
      issueId: json['issue_id'] as String,
      dependsOnId: json['depends_on_id'] as String,
      type: (json['type'] as String?) ?? 'blocks',
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: (json['created_by'] as String?) ?? '',
      metadata: (json['metadata'] as String?) ?? '{}',
    );
  }

  Map<String, dynamic> toJson() => {
        'issue_id': issueId,
        'depends_on_id': dependsOnId,
        'type': type,
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
        'metadata': metadata,
      };
}
