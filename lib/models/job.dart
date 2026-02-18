class Job {
  String id;
  String title;
  String company;
  String description;
  String location;
  String type; // 'Internship' or 'Full-time'
  double minCgpa;
  List<String> requiredSkills;
  List<String> eligibleDegrees;
  DateTime deadline;
  String? salary;
  String? applyLink;
  bool isActive;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.location,
    required this.type,
    required this.minCgpa,
    required this.requiredSkills,
    required this.eligibleDegrees,
    required this.deadline,
    this.salary,
    this.applyLink,
    this.isActive = true,
  });

  bool isEligible({
    required double studentCgpa,
    required List<String> studentSkills,
    required String studentDegree,
  }) {
    bool cgpaMatch = studentCgpa >= minCgpa;
    bool skillsMatch = requiredSkills.any((skill) => 
      studentSkills.any((s) => s.toLowerCase().contains(skill.toLowerCase()))
    );
    bool degreeMatch = eligibleDegrees.contains(studentDegree) || 
                       eligibleDegrees.contains('Any');
    
    return cgpaMatch && skillsMatch && degreeMatch;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'location': location,
      'type': type,
      'minCgpa': minCgpa,
      'requiredSkills': requiredSkills,
      'eligibleDegrees': eligibleDegrees,
      'deadline': deadline.toIso8601String(),
      'salary': salary,
      'applyLink': applyLink,
      'isActive': isActive,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? 'Internship',
      minCgpa: (map['minCgpa'] ?? 0.0).toDouble(),
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      eligibleDegrees: List<String>.from(map['eligibleDegrees'] ?? []),
      deadline: DateTime.parse(map['deadline']),
      salary: map['salary'],
      applyLink: map['applyLink'],
      isActive: map['isActive'] ?? true,
    );
  }
}
