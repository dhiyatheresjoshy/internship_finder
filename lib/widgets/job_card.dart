import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/job.dart';
import '../providers/app_provider.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobCard({
    Key? key,
    required this.job,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isBookmarked = provider.isBookmarked(job.id);
    final daysLeft = job.deadline.difference(DateTime.now()).inDays;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          job.company,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleBookmark(job.id);
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(job.location, style: TextStyle(color: Colors.grey[600])),
                  SizedBox(width: 16),
                  Icon(Icons.work, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(job.type, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 8),
              if (job.salary != null)
                Row(
                  children: [
                    Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      job.salary!,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.requiredSkills.take(3).map((skill) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: daysLeft <= 5 ? Colors.red[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  daysLeft <= 0 
                      ? 'Deadline passed' 
                      : 'Deadline: ${daysLeft} day${daysLeft == 1 ? '' : 's'} left',
                  style: TextStyle(
                    fontSize: 12,
                    color: daysLeft <= 5 ? Colors.red[700] : Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
