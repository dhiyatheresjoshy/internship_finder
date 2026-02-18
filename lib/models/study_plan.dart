class StudyPlan {
  String id;
  String jobId;
  String jobTitle;
  List<String> topicsToStudy;
  Map<String, List<String>> dailyPlan; // Day -> Topics
  DateTime startDate;
  DateTime targetDate;
  Map<String, bool> completionStatus; // Topic -> Completed

  StudyPlan({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.topicsToStudy,
    required this.dailyPlan,
    required this.startDate,
    required this.targetDate,
    Map<String, bool>? completionStatus,
  }) : completionStatus = completionStatus ?? 
       {for (var topic in topicsToStudy) topic: false};

  int get totalDays => targetDate.difference(startDate).inDays + 1;
  
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  
  double get progressPercentage {
    if (topicsToStudy.isEmpty) return 0.0;
    int completed = completionStatus.values.where((v) => v).length;
    return (completed / topicsToStudy.length) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'topicsToStudy': topicsToStudy,
      'dailyPlan': dailyPlan,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'completionStatus': completionStatus,
    };
  }

  factory StudyPlan.fromMap(Map<String, dynamic> map) {
    return StudyPlan(
      id: map['id'] ?? '',
      jobId: map['jobId'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      topicsToStudy: List<String>.from(map['topicsToStudy'] ?? []),
      dailyPlan: Map<String, List<String>>.from(
        (map['dailyPlan'] as Map).map(
          (key, value) => MapEntry(key, List<String>.from(value))
        )
      ),
      startDate: DateTime.parse(map['startDate']),
      targetDate: DateTime.parse(map['targetDate']),
      completionStatus: Map<String, bool>.from(map['completionStatus'] ?? {}),
    );
  }

  static StudyPlan generate({
    required String jobId,
    required String jobTitle,
    required List<String> topics,
    required DateTime deadline,
  }) {
    DateTime startDate = DateTime.now();
    int daysAvailable = deadline.difference(startDate).inDays;
    
    if (daysAvailable <= 0) daysAvailable = 1;
    
    Map<String, List<String>> plan = {};
    int topicsPerDay = (topics.length / daysAvailable).ceil();
    if (topicsPerDay == 0) topicsPerDay = 1;
    
    int topicIndex = 0;
    for (int day = 0; day < daysAvailable; day++) {
      DateTime currentDay = startDate.add(Duration(days: day));
      String dayKey = 'Day ${day + 1}';
      List<String> dailyTopics = [];
      
      for (int i = 0; i < topicsPerDay && topicIndex < topics.length; i++) {
        dailyTopics.add(topics[topicIndex]);
        topicIndex++;
      }
      
      if (dailyTopics.isNotEmpty) {
        plan[dayKey] = dailyTopics;
      }
    }
    
    return StudyPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: jobId,
      jobTitle: jobTitle,
      topicsToStudy: topics,
      dailyPlan: plan,
      startDate: startDate,
      targetDate: deadline,
    );
  }
}
