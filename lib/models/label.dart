class Label {
  final String issueId;
  final String label;

  const Label({
    required this.issueId,
    required this.label,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      issueId: json['issue_id'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'issue_id': issueId,
        'label': label,
      };
}
