import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ReminderCard({
    Key? key,
    required this.reminder,
    this.onToggle,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  Color _getCardColor() {
    if (reminder.isCompleted) return Colors.grey[100]!;
    if (reminder.isOverdue) return Colors.red[50]!;
    if (reminder.isDueSoon) return Colors.orange[50]!;
    return Colors.white;
  }

  Color _getTextColor() {
    if (reminder.isCompleted) return Colors.grey[600]!;
    if (reminder.isOverdue) return Colors.red[700]!;
    if (reminder.isDueSoon) return Colors.orange[700]!;
    return Colors.black87;
  }

  IconData _getTypeIcon() {
    switch (reminder.type) {
      case 'Application':
        return Icons.assignment;
      case 'Test':
        return Icons.quiz;
      case 'Interview':
        return Icons.video_call;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _getCardColor(),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: reminder.isCompleted,
                onChanged: (_) => onToggle?.call(),
                shape: CircleBorder(),
              ),
              Icon(
                _getTypeIcon(),
                color: _getTextColor(),
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.jobTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(),
                        decoration: reminder.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      reminder.company,
                      style: TextStyle(
                        fontSize: 14,
                        color: _getTextColor().withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: _getTextColor().withOpacity(0.7),
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(reminder.reminderDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getTextColor().withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTextColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reminder.type,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getTextColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
