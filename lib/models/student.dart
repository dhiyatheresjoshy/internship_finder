class Student {
  String id;
  String name;
  String email;
  String college;
  String degree;
  int graduationYear;
  double cgpa;
  List<String> skills;
  String? phoneNumber;
  String? bio;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.college,
    required this.degree,
    required this.graduationYear,
    required this.cgpa,
    required this.skills,
    this.phoneNumber,
    this.bio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'college': college,
      'degree': degree,
      'graduationYear': graduationYear,
      'cgpa': cgpa,
      'skills': skills,
      'phoneNumber': phoneNumber,
      'bio': bio,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      college: map['college'] ?? '',
      degree: map['degree'] ?? '',
      graduationYear: map['graduationYear'] ?? 2024,
      cgpa: (map['cgpa'] ?? 0.0).toDouble(),
      skills: List<String>.from(map['skills'] ?? []),
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
    );
  }
}
