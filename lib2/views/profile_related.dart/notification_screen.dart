import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notifications data
  final List<Map<String, String>> todayNotifications = [
    {
      "title": "Payment Successful!",
      "subtitle": "Cash received. Ride completed successfully.",
      "time": "1 hour ago",
      "icon": "assets/images/online-payment.png"
    },
  ];

  final List<Map<String, String>> yesterdayNotifications = [
    {
      "title": "Payment Successful!",
      "subtitle": "Ride canceled by user.",
      "time": "Yesterday, 5 PM",
      "icon": "assets/images/Ellipse.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
  title: const Text(
    "Notifications",
    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // optional: text color
  ),
  backgroundColor: Colors.white,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.black, // back icon color
    ),
    onPressed: () {
      Navigator.pop(context); // go back when pressed
    },
  ),
),

      // appBar: AppBar(
      //   title: const Text("Notifications"),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Today",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...todayNotifications.map((notification) => NotificationCard(
                notification: notification,
                backgroundColor: Color(0xFFEFFCFC), // light blue background for today
              )),

          const SizedBox(height: 20),
          const Text(
            "Yesterday",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...yesterdayNotifications.map((notification) => NotificationCard(
                notification: notification,
                backgroundColor: Colors.white, // light grey background for yesterday
              )),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, String> notification;
  final Color backgroundColor;

  const NotificationCard({
    super.key,
    required this.notification,
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
            Image.asset(
              notification['icon']!,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['subtitle']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
