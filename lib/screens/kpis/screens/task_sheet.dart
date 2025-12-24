import 'package:company_portal/screens/kpis/widgets/achievement_line.dart';
import 'package:company_portal/screens/kpis/widgets/tasks_screen.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class TaskSheet extends StatefulWidget {
  const TaskSheet({super.key});

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  final List<TimelineItem> items = [
    TimelineItem(
        title: 'UI | UX Design',
        date: 'Sep 07 2024',
        isCompleted: true,
        description: 'Discuss and Deploy UI | UX'),
    TimelineItem(
        title: 'Prototyping',
        date: 'Sep 12 2024',
        isCompleted: true,
        description: 'Need to create a prototype for managers on Tuesday'),
    TimelineItem(
        title: 'App Theme',
        date: 'Sep 16 2024',
        description: 'Add Dark and light theme'),
    TimelineItem(
        title: 'Login Screen',
        date: 'Sep 18 2024',
        description: 'Did you integrate with microsoft login in your app?'),
    TimelineItem(
        title: 'Home Screen',
        date: 'Sep 20 2024',
        description: 'Create Home Screen with Navigation Bar'),
  ];

  double calculatePercentage(){
    int completedTasks = 0;
    for(var item in items){
      if(item.isCompleted){
        completedTasks ++;
      }
    }
    print("Percentage: ${(completedTasks / items.length)}");
    return (completedTasks / items.length);
  }
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(title: "Task Sheet", backBtn: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AchievementLine(progress: calculatePercentage()),
            Expanded(child: TimelineScreen(items: items, onItemChanged: () {
              setState(() {}); //  recalculate percentage
            },))
          ],
        ),
      ),
    );
  }
}
