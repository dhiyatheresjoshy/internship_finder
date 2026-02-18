class Reminder {
  String id;
  String jobId;
  String jobTitle;
  String company;
  String type; // 'Application', 'Test', 'Interview', 'Custom'
  DateTime reminderDate;
  String? notes;
  bool isCompleted;
  DateTime createdAt;

  Reminder({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.type,
    required this.reminderDate,
    this.notes,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue => 
    !isCompleted && reminderDate.isBefore(DateTime.now());

  bool get isDueSoon => 
    !isCompleted && 
    reminderDate.isAfter(DateTime.now()) &&
    reminderDate.difference(DateTime.now()).inDays <= 3;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'company': company,
      'type': type,
      'reminderDate': reminderDate.toIso8601String(),
      'notes': notes,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] ?? '',
      jobId: map['jobId'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      company: map['company'] ?? '',
      type: map['type'] ?? 'Application',
      reminderDate: DateTime.parse(map['reminderDate']),
      notes: map['notes'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
