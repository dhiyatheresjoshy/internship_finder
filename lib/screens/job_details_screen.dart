import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/job.dart';
import '../models/reminder.dart';
import '../models/study_plan.dart';
import '../providers/app_provider.dart';
import 'study_plan_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isBookmarked = provider.isBookmarked(job.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              provider.toggleBookmark(job.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    job.company,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.location_on,
                        label: job.location,
                      ),
                      SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.work,
                        label: job.type,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Salary
            if (job.salary != null)
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.currency_rupee, color: Colors.green[700]),
                      SizedBox(width: 8),
                      Text(
                        job.salary!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this role',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    job.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Requirements
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _RequirementItem(
                    icon: Icons.school,
                    title: 'Minimum CGPA',
                    value: job.minCgpa.toString(),
                  ),
                  SizedBox(height: 8),
                  _RequirementItem(
                    icon: Icons.book,
                    title: 'Eligible Degrees',
                    value: job.eligibleDegrees.join(', '),
                  ),
                  SizedBox(height: 8),
                  _RequirementItem(
                    icon: Icons.code,
                    title: 'Required Skills',
                    value: job.requiredSkills.join(', '),
                  ),
                  SizedBox(height: 8),
                  _RequirementItem(
                    icon: Icons.calendar_today,
                    title: 'Deadline',
                    value: DateFormat('MMM dd, yyyy').format(job.deadline),
                    isUrgent: job.deadline.difference(DateTime.now()).inDays <= 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _showReminderDialog(context, provider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm_add, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Set Reminder',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _createStudyPlan(context, provider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Create Study Plan',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (job.applyLink != null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showApplyConfirmation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Apply Now',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog(BuildContext context, AppProvider provider) {
    DateTime selectedDate = DateTime.now().add(Duration(days: 1));
    String reminderType = 'Application';
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Set Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reminder Type'),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: reminderType,
                      items: ['Application', 'Test', 'Interview', 'Custom']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          reminderType = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Date'),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: job.deadline,
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final reminder = Reminder(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      jobId: job.id,
                      jobTitle: job.title,
                      company: job.company,
                      type: reminderType,
                      reminderDate: selectedDate,
                      notes: notesController.text.isEmpty ? null : notesController.text,
                    );
                    provider.addReminder(reminder);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reminder set successfully!')),
                    );
                  },
                  child: Text('Set Reminder'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createStudyPlan(BuildContext context, AppProvider provider) {
    final studyPlan = StudyPlan.generate(
      jobId: job.id,
      jobTitle: job.title,
      topics: job.requiredSkills,
      deadline: job.deadline,
    );
    
    provider.addStudyPlan(studyPlan);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyPlanScreen(studyPlan: studyPlan),
      ),
    );
  }

  void _showApplyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Apply for this job?'),
          content: Text(
            'This will open the application link in your browser. Make sure you have your resume and documents ready.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening application link...'),
                    action: SnackBarAction(
                      label: 'Open',
                      onPressed: () {
                        // In real app, launch URL here
                      },
                    ),
                  ),
                );
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isUrgent;

  const _RequirementItem({
    required this.icon,
    required this.title,
    required this.value,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isUrgent ? Colors.red[700] : Colors.grey[700],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isUrgent ? Colors.red[700] : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
