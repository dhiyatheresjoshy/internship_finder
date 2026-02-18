import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../models/job.dart';
import '../models/reminder.dart';
import '../models/study_plan.dart';

class AppProvider extends ChangeNotifier {
  Student? _student;
  List<Job> _allJobs = [];
  List<String> _bookmarkedJobIds = [];
  List<Reminder> _reminders = [];
  List<StudyPlan> _studyPlans = [];
  String _selectedJobType = 'All'; // All, Internship, Full-time
  double _minCgpaFilter = 0.0;

  // Getters
  Student? get student => _student;
  List<Job> get allJobs => _allJobs;
  List<String> get bookmarkedJobIds => _bookmarkedJobIds;
  List<Reminder> get reminders => _reminders;
  List<StudyPlan> get studyPlans => _studyPlans;
  String get selectedJobType => _selectedJobType;
  double get minCgpaFilter => _minCgpaFilter;

  // Computed getters
  bool get hasProfile => _student != null;
  
  List<Job> get eligibleJobs {
    if (_student == null) return [];
    
    return _allJobs.where((job) {
      bool typeMatch = _selectedJobType == 'All' || job.type == _selectedJobType;
      bool cgpaMatch = job.minCgpa >= _minCgpaFilter;
      bool isEligible = job.isEligible(
        studentCgpa: _student!.cgpa,
        studentSkills: _student!.skills,
        studentDegree: _student!.degree,
      );
      
      return typeMatch && cgpaMatch && isEligible && job.isActive;
    }).toList();
  }
  
  List<Job> get bookmarkedJobs {
    return _allJobs.where((job) => _bookmarkedJobIds.contains(job.id)).toList();
  }
  
  List<Reminder> get upcomingReminders {
    return _reminders
        .where((r) => !r.isCompleted && r.reminderDate.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }
  
  List<Reminder> get overdueReminders {
    return _reminders.where((r) => r.isOverdue).toList();
  }

  // Student methods
  void setStudent(Student student) {
    _student = student;
    notifyListeners();
  }

  void updateStudent(Student student) {
    _student = student;
    notifyListeners();
  }

  void clearStudent() {
    _student = null;
    notifyListeners();
  }

  // Job methods
  void setJobs(List<Job> jobs) {
    _allJobs = jobs;
    notifyListeners();
  }

  void addJob(Job job) {
    _allJobs.add(job);
    notifyListeners();
  }

  Job? getJobById(String id) {
    try {
      return _allJobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  void setJobTypeFilter(String type) {
    _selectedJobType = type;
    notifyListeners();
  }

  void setMinCgpaFilter(double cgpa) {
    _minCgpaFilter = cgpa;
    notifyListeners();
  }

  // Bookmark methods
  void toggleBookmark(String jobId) {
    if (_bookmarkedJobIds.contains(jobId)) {
      _bookmarkedJobIds.remove(jobId);
    } else {
      _bookmarkedJobIds.add(jobId);
    }
    notifyListeners();
  }

  bool isBookmarked(String jobId) {
    return _bookmarkedJobIds.contains(jobId);
  }

  // Reminder methods
  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void updateReminder(Reminder reminder) {
    int index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      notifyListeners();
    }
  }

  void deleteReminder(String id) {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void toggleReminderComplete(String id) {
    int index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      notifyListeners();
    }
  }

  // Study Plan methods
  void addStudyPlan(StudyPlan plan) {
    _studyPlans.add(plan);
    notifyListeners();
  }

  void updateStudyPlan(StudyPlan plan) {
    int index = _studyPlans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _studyPlans[index] = plan;
      notifyListeners();
    }
  }

  void deleteStudyPlan(String id) {
    _studyPlans.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void toggleTopicCompletion(String planId, String topic) {
    int index = _studyPlans.indexWhere((p) => p.id == planId);
    if (index != -1) {
      _studyPlans[index].completionStatus[topic] = 
          !(_studyPlans[index].completionStatus[topic] ?? false);
      notifyListeners();
    }
  }

  // Initialize with sample data
  void initializeSampleData() {
    _allJobs = [
      Job(
        id: '1',
        title: 'Software Development Intern',
        company: 'Google',
        description: 'Work on cutting-edge technologies and build scalable solutions. You will collaborate with experienced engineers and contribute to real-world projects.',
        location: 'Bangalore, India',
        type: 'Internship',
        minCgpa: 7.5,
        requiredSkills: ['Flutter', 'Dart', 'Firebase'],
        eligibleDegrees: ['B.Tech', 'B.E', 'MCA'],
        deadline: DateTime.now().add(Duration(days: 15)),
        salary: '₹50,000/month',
        applyLink: 'https://google.com/careers',
      ),
      Job(
        id: '2',
        title: 'Frontend Developer',
        company: 'Microsoft',
        description: 'Join our team to create amazing user experiences. Work with React, TypeScript, and modern web technologies.',
        location: 'Hyderabad, India',
        type: 'Full-time',
        minCgpa: 7.0,
        requiredSkills: ['React', 'JavaScript', 'CSS'],
        eligibleDegrees: ['B.Tech', 'B.E', 'BCA', 'MCA'],
        deadline: DateTime.now().add(Duration(days: 20)),
        salary: '₹12-15 LPA',
        applyLink: 'https://microsoft.com/careers',
      ),
      Job(
        id: '3',
        title: 'Data Science Intern',
        company: 'Amazon',
        description: 'Analyze large datasets and build machine learning models to solve business problems.',
        location: 'Mumbai, India',
        type: 'Internship',
        minCgpa: 8.0,
        requiredSkills: ['Python', 'Machine Learning', 'SQL'],
        eligibleDegrees: ['B.Tech', 'B.E', 'M.Tech'],
        deadline: DateTime.now().add(Duration(days: 10)),
        salary: '₹60,000/month',
        applyLink: 'https://amazon.jobs',
      ),
      Job(
        id: '4',
        title: 'Mobile App Developer',
        company: 'Flipkart',
        description: 'Build mobile applications used by millions of users. Work with Flutter and native technologies.',
        location: 'Bangalore, India',
        type: 'Full-time',
        minCgpa: 6.5,
        requiredSkills: ['Flutter', 'Dart', 'Mobile Development'],
        eligibleDegrees: ['B.Tech', 'B.E', 'BCA'],
        deadline: DateTime.now().add(Duration(days: 25)),
        salary: '₹10-12 LPA',
        applyLink: 'https://flipkart.com/careers',
      ),
      Job(
        id: '5',
        title: 'Backend Developer Intern',
        company: 'Zomato',
        description: 'Work on scalable backend systems handling millions of requests. Learn from experienced engineers.',
        location: 'Gurugram, India',
        type: 'Internship',
        minCgpa: 7.0,
        requiredSkills: ['Node.js', 'MongoDB', 'REST APIs'],
        eligibleDegrees: ['B.Tech', 'B.E', 'MCA'],
        deadline: DateTime.now().add(Duration(days: 12)),
        salary: '₹40,000/month',
        applyLink: 'https://zomato.com/careers',
      ),
      Job(
        id: '6',
        title: 'Full Stack Developer',
        company: 'Swiggy',
        description: 'End-to-end development of features. Work with modern tech stack including React and Node.js.',
        location: 'Bangalore, India',
        type: 'Full-time',
        minCgpa: 7.5,
        requiredSkills: ['React', 'Node.js', 'MongoDB'],
        eligibleDegrees: ['B.Tech', 'B.E', 'MCA'],
        deadline: DateTime.now().add(Duration(days: 18)),
        salary: '₹15-18 LPA',
        applyLink: 'https://swiggy.com/careers',
      ),
    ];
    
    notifyListeners();
  }
}
