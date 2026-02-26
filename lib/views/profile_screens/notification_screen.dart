// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:nzcu_driver/services/notification_service_controller.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {

//     // final NotificationController notificationController = Get.find<NotificationController>();

//   // Sample notifications data
//   final List<Map<String, String>> todayNotifications = [
//     {
//       "title": "Payment Successful!",
//       "subtitle": "Cash received. Ride completed successfully.",
//       "time": "1 hour ago",
//       "icon": "assets/images/online-payment.png"
//     },
//   ];

//   final List<Map<String, String>> yesterdayNotifications = [
//     {
//       "title": "Payment Successful!",
//       "subtitle": "Ride canceled by user.",
//       "time": "Yesterday, 5 PM",
//       "icon": "assets/images/Ellipse.png"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leadingWidth: 30,
//   title: const Text(
//     "Notifications",
//     style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // optional: text color
//   ),
//   backgroundColor: Colors.white,
//   elevation: 0,
//   leading: IconButton(
//     icon: const Icon(
//       Icons.arrow_back,
//       color: Colors.black, // back icon color
//     ),
//     onPressed: () {
//       Navigator.pop(context); // go back when pressed
//     },
//   ),
// ),

//       // appBar: AppBar(
//       //   title: const Text("Notifications"),
//       //   backgroundColor: Colors.white,
//       //   elevation: 0,
//       // ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text(
//             "Today",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ...todayNotifications.map((notification) => NotificationCard(
//                 notification: notification,
//                 backgroundColor: Color(0xFFEFFCFC), // light blue background for today
//               )),

//           const SizedBox(height: 20),
//           const Text(
//             "Yesterday",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ...yesterdayNotifications.map((notification) => NotificationCard(
//                 notification: notification,
//                 backgroundColor: Colors.white, // light grey background for yesterday
//               )),
//         ],
//       ),
//     );
//   }
// }

// class NotificationCard extends StatelessWidget {
//   final Map<String, String> notification;
//   final Color backgroundColor;

//   const NotificationCard({
//     super.key,
//     required this.notification,
//     required this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: backgroundColor,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               notification['icon']!,
//               width: 40,
//               height: 40,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     notification['title']!,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     notification['subtitle']!,
//                     style: const TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     notification['time']!,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:nzcu_driver/controllers/profile_controllers/notification_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/notification_response.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  void initState() {
    notificationController.getNotifications();
    super.initState();
  }

  bool _isToday(String dateString) {
    try {
      final notificationDate = DateTime.parse(dateString);
      final today = DateTime.now();
      return notificationDate.year == today.year &&
          notificationDate.month == today.month &&
          notificationDate.day == today.day;
    } catch (e) {
      return false;
    }
  }

  bool _isYesterday(String dateString) {
    try {
      final notificationDate = DateTime.parse(dateString);
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      return notificationDate.year == yesterday.year &&
          notificationDate.month == yesterday.month &&
          notificationDate.day == yesterday.day;
    } catch (e) {
      return false;
    }
  }

  String _formatDateTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      }
    } catch (e) {
      return 'Some time ago';
    }
  }

  String _getIconForNotification(String title) {
    title = title.toLowerCase();
    if (title.contains('payment') || title.contains('cash')) {
      return 'assets/images/online-payment.png';
    } else if (title.contains('cancel')) {
      return 'assets/images/Ellipse.png';
    } else if (title.contains('ride') || title.contains('trip')) {
      return 'assets/images/ride-icon.png';
    } else {
      return 'assets/images/notification-icon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notificationController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${notificationController.errorMessage.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final response = notificationController.cashResponse.value;
        final notifications = response?.data ?? [];

        if (notifications.isEmpty) {
          return const Center(
            child: Text(
              'No notifications found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final todayNotifications = notifications
            .where((n) => _isToday(n.createdAt ?? ''))
            .toList();
        final yesterdayNotifications = notifications
            .where((n) => _isYesterday(n.createdAt ?? ''))
            .toList();
        final olderNotifications = notifications
            .where(
              (n) =>
                  !_isToday(n.createdAt ?? '') &&
                  !_isYesterday(n.createdAt ?? ''),
            )
            .toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (todayNotifications.isNotEmpty) ...[
              const Text(
                "Today",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...todayNotifications.map(
                (notification) => NotificationCard(
                  notification: notification,
                  formattedTime: _formatDateTime(notification.createdAt ?? ''),
                  iconPath: _getIconForNotification(notification.title ?? ''),
                  backgroundColor: const Color(0xFFEFFCFC),
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (yesterdayNotifications.isNotEmpty) ...[
              const Text(
                "Yesterday",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...yesterdayNotifications.map(
                (notification) => NotificationCard(
                  notification: notification,
                  formattedTime: _formatDateTime(notification.createdAt ?? ''),
                  iconPath: _getIconForNotification(notification.title ?? ''),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (olderNotifications.isNotEmpty) ...[
              const Text(
                "Older",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...olderNotifications.map(
                (notification) => NotificationCard(
                  notification: notification,
                  formattedTime: _formatDateTime(notification.createdAt ?? ''),
                  iconPath: _getIconForNotification(notification.title ?? ''),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final String formattedTime;
  final String iconPath;
  final Color backgroundColor;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.formattedTime,
    required this.iconPath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getIconData(notification.title ?? ''),
                color: Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Notification',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body ?? 'No content',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      if (notification.seen == false)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'New',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String title) {
    title = title.toLowerCase();
    if (title.contains('payment') ||
        title.contains('cash') ||
        title.contains('success')) {
      return Icons.payment;
    } else if (title.contains('cancel')) {
      return Icons.cancel;
    } else if (title.contains('ride') || title.contains('trip')) {
      return Icons.directions_car;
    } else if (title.contains('alert') || title.contains('warning')) {
      return Icons.warning;
    } else if (title.contains('info') || title.contains('update')) {
      return Icons.info;
    } else {
      return Icons.notifications;
    }
  }
}
