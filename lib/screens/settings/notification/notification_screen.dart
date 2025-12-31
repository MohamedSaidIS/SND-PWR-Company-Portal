import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../utils/export_import.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // final List<Map<String, dynamic>> notifications = [
  //   {
  //     "title": "New Message",
  //     "subtitle": "You received a message from John",
  //     "icon": Icons.message,
  //     "iconColor": Colors.blue,
  //     "bgColor": Colors.white,
  //     "type": "message"
  //   },
  //   {
  //     "title": "Reminder",
  //     "subtitle": "Meeting at 3 PM",
  //     "icon": Icons.calendar_today,
  //     "iconColor": Colors.orange,
  //     "bgColor": Colors.yellow[100],
  //     "type": "reminder"
  //   },
  //   {
  //     "title": "Vacation Approved",
  //     "subtitle": "Your vacation request has been approved",
  //     "icon": Icons.beach_access,
  //     "iconColor": Colors.teal,
  //     "bgColor": Colors.green[100],
  //     "type": "update"
  //   },
  //   {
  //     "title": "New Update is here",
  //     "subtitle": "Update number 1.2.0",
  //     "icon": Icons.update,
  //     "iconColor": Colors.orangeAccent,
  //     "bgColor": Colors.orange[50],
  //     "type": "update"
  //   },
  //   {
  //     "title": "New Message",
  //     "subtitle": "You received a message from John",
  //     "icon": Icons.message,
  //     "iconColor": Colors.blue,
  //     "type": "message"
  //   },
  //   {
  //     "title": "Reminder",
  //     "subtitle": "Meeting at 3 PM",
  //     "icon": Icons.calendar_today,
  //     "iconColor": Colors.orange,
  //     "type": "reminder"
  //   },
  //   {
  //     "title": "Vacation Approved",
  //     "subtitle": "Your vacation request has been approved",
  //     "icon": Icons.beach_access,
  //     "iconColor": Colors.teal,
  //     "type": "update"
  //   },
  //   {
  //     "title": "New Update is here",
  //     "subtitle": "Update number 1.2.0",
  //     "icon": Icons.update,
  //     "iconColor": Colors.orangeAccent,
  //     "type": "update"
  //   },
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final notificationSearch = getNotificationSearch(local);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.notifications,
          backBtn: true,
        ),
        body: Consumer<NotificationProvider>(
          builder: (_, provider, __) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: notificationSearch.length,
                          itemBuilder: (context, index) {
                            final item = notificationSearch[index];
                            return FilterButton(
                              text: item['label']!,
                              selected:
                                  provider.selectedFilter == item['value'],
                              onPressed: () =>
                                  provider.applyFilter(item['value']!),
                            );
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: provider.notifications.isEmpty
                      ? const Center(
                          child: Text('No notifications'),
                        )
                      : ListView.builder(
                          itemCount: provider.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = provider.notifications[index];
                            return Card(
                              color: getNotificationBackgroundColor(
                                  notification.data['notificationType']),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  getNotificationIcon(
                                      notification.data['notificationType']),
                                  color: getNotificationIconColor(
                                      notification.data['notificationType']),
                                ),
                                title: Text(notification.title ?? ''),
                                subtitle: Text(notification.body ?? ''),
                                trailing: notification.isRead
                                    ? null
                                    : const Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                onTap: () {
                                  provider.markAsRead(notification.id);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blueAccent : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               context.read<NotificationProvider>().clearAll();
//             },
//           ),
//         ],
//       ),
//       body: Consumer<NotificationProvider>(
//         builder: (_, provider, __) {
//           if (provider.notifications.isEmpty) {
//             return const Center(
//               child: Text('No notifications'),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: provider.notifications.length,
//             itemBuilder: (_, i) {
//               final n = provider.notifications[i];
//
//               return ListTile(
//                 title: Text(n.title ?? ''),
//                 subtitle: Text(n.body ?? ''),
//                 trailing: n.isRead
//                     ? null
//                     : const Icon(Icons.circle, size: 10),
//                 onTap: () {
//                   provider.markAsRead(n.id);
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
