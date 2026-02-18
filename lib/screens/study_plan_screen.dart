import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/study_plan.dart';
import '../providers/app_provider.dart';

class StudyPlanScreen extends StatelessWidget {
  final StudyPlan studyPlan;

  const StudyPlanScreen({Key? key, required this.studyPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Study Plan'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, provider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studyPlan.jobTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 6),
                      Text(
                        '${DateFormat('MMM dd').format(studyPlan.startDate)} - ${DateFormat('MMM dd, yyyy').format(studyPlan.targetDate)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 6),
                      Text(
                        '${studyPlan.daysRemaining} days remaining',
                        style: TextStyle(
                          color: studyPlan.daysRemaining <= 3 
                              ? Colors.red[700] 
                              : Colors.grey[700],
                          fontWeight: studyPlan.daysRemaining <= 3 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Progress
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${studyPlan.progressPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: studyPlan.progressPercentage / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.purple,
                      minHeight: 10,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${studyPlan.completionStatus.values.where((v) => v).length} of ${studyPlan.topicsToStudy.length} topics completed',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            
            // Daily Plan
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Daily Study Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),
            
            ...studyPlan.dailyPlan.entries.map((entry) {
              return _DayCard(
                dayTitle: entry.key,
                topics: entry.value,
                studyPlan: studyPlan,
                onTopicToggle: (topic) {
                  provider.toggleTopicCompletion(studyPlan.id, topic);
                },
              );
            }).toList(),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Study Plan'),
          content: Text('Are you sure you want to delete this study plan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteStudyPlan(studyPlan.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close study plan screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Study plan deleted')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  final String dayTitle;
  final List<String> topics;
  final StudyPlan studyPlan;
  final Function(String) onTopicToggle;

  const _DayCard({
    required this.dayTitle,
    required this.topics,
    required this.studyPlan,
    required this.onTopicToggle,
  });

  @override
  Widget build(BuildContext context) {
    int completedTopics = topics
        .where((topic) => studyPlan.completionStatus[topic] == true)
        .length;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: completedTopics == topics.length
                      ? Colors.green[100]
                      : Colors.purple[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completedTopics == topics.length
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: completedTopics == topics.length
                      ? Colors.green[700]
                      : Colors.purple[700],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completedTopics/${topics.length} topics completed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: topics.map((topic) {
                  bool isCompleted = studyPlan.completionStatus[topic] == true;
                  return CheckboxListTile(
                    title: Text(
                      topic,
                      style: TextStyle(
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: isCompleted,
                    onChanged: (_) => onTopicToggle(topic),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
