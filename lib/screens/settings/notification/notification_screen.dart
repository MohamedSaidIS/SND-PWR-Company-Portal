import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> filteredNotifications = [];
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "New Message",
      "subtitle": "You received a message from John",
      "icon": Icons.message,
      "iconColor": Colors.blue,
      "bgColor": Colors.white,
      "type": "message"
    },
    {
      "title": "Reminder",
      "subtitle": "Meeting at 3 PM",
      "icon": Icons.calendar_today,
      "iconColor": Colors.orange,
      "bgColor": Colors.yellow[100],
      "type": "reminder"
    },
    {
      "title": "Vacation Approved",
      "subtitle": "Your vacation request has been approved",
      "icon": Icons.beach_access,
      "iconColor": Colors.teal,
      "bgColor": Colors.green[100],
      "type": "update"
    },
    {
      "title": "New Update is here",
      "subtitle": "Update number 1.2.0",
      "icon": Icons.update,
      "iconColor": Colors.orangeAccent,
      "bgColor": Colors.orange[50],
      "type": "update"
    },
    {
      "title": "New Message",
      "subtitle": "You received a message from John",
      "icon": Icons.message,
      "iconColor": Colors.blue,
      "type": "message"
    },
    {
      "title": "Reminder",
      "subtitle": "Meeting at 3 PM",
      "icon": Icons.calendar_today,
      "iconColor": Colors.orange,
      "type": "reminder"
    },
    {
      "title": "Vacation Approved",
      "subtitle": "Your vacation request has been approved",
      "icon": Icons.beach_access,
      "iconColor": Colors.teal,
      "type": "update"
    },
    {
      "title": "New Update is here",
      "subtitle": "Update number 1.2.0",
      "icon": Icons.update,
      "iconColor": Colors.orangeAccent,
      "type": "update"
    },
  ];
  String selectedFilter = "all";

  @override
  void initState() {
    super.initState();
    filteredNotifications = List.from(notifications);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.notifications,
          backBtn: true,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 8),
                  FilterButton(
                    text: local.all,
                    selected: selectedFilter == "all",
                    onPressed: () {
                      setState(() {
                        selectedFilter = "all";
                        filteredNotifications = notifications.toList();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: local.message,
                    selected: selectedFilter == "message",
                    onPressed: () {
                      setState(() {
                        selectedFilter = "message";
                        filteredNotifications = notifications
                            .where((n) => n["type"] == selectedFilter)
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: local.reminder,
                    selected: selectedFilter == "reminder",
                    onPressed: () {
                      setState(() {
                        selectedFilter = "reminder";
                        filteredNotifications = notifications
                            .where((n) => n["type"] == selectedFilter)
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: local.update,
                    selected: selectedFilter == "update",
                    onPressed: () {
                      setState(() {
                        selectedFilter = "update";
                        filteredNotifications = notifications
                            .where((n) => n["type"] == selectedFilter)
                            .toList();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotifications.length,
                itemBuilder: (context, index) {
                  final notification = filteredNotifications[index];
                  print("List Builder ${filteredNotifications.length}");

                  return Card(
                    color: notification["bgColor"],
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        notification["icon"],
                        color: notification["iconColor"],
                      ),
                      title: Text(notification["title"]!),
                      subtitle: Text(notification["subtitle"]!),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blueAccent : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
