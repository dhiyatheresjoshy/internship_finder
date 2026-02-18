import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/reminder_card.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final allReminders = provider.reminders;
    final overdueReminders = provider.overdueReminders;
    final upcomingReminders = provider.upcomingReminders;
    final completedReminders = allReminders.where((r) => r.isCompleted).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reminders'),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Upcoming (${upcomingReminders.length})'),
              Tab(text: 'Overdue (${overdueReminders.length})'),
              Tab(text: 'Completed (${completedReminders.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRemindersList(context, provider, upcomingReminders, 'upcoming'),
            _buildRemindersList(context, provider, overdueReminders, 'overdue'),
            _buildRemindersList(context, provider, completedReminders, 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersList(
    BuildContext context,
    AppProvider provider,
    List reminders,
    String type,
  ) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'completed' ? Icons.check_circle_outline : Icons.notifications_off,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              type == 'upcoming'
                  ? 'No upcoming reminders'
                  : type == 'overdue'
                      ? 'No overdue reminders'
                      : 'No completed reminders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              type == 'upcoming'
                  ? 'Set reminders for job applications'
                  : type == 'overdue'
                      ? 'Great! You\'re all caught up'
                      : 'Complete tasks to see them here',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        return ReminderCard(
          reminder: reminders[index],
          onToggle: () {
            provider.toggleReminderComplete(reminders[index].id);
          },
          onDelete: () {
            _showDeleteConfirmation(context, provider, reminders[index].id);
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AppProvider provider,
    String reminderId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Reminder'),
          content: Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteReminder(reminderId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reminder deleted')),
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
