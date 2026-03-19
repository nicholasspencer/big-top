class Event {
  final String id;
  final String issueId;
  final String eventType;
  final String actor;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  const Event({
    required this.id,
    required this.issueId,
    required this.eventType,
    this.actor = '',
    required this.createdAt,
    this.data = const {},
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      issueId: json['issue_id'] as String,
      eventType: json['event_type'] as String,
      actor: (json['actor'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      data: (json['data'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'issue_id': issueId,
        'event_type': eventType,
        'actor': actor,
        'created_at': createdAt.toIso8601String(),
        'data': data,
      };
}
