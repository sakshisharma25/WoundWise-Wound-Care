import 'package:flutter/material.dart';
import 'package:woundwise/future/notification_futures.dart';
import 'package:woundwise/models/notification_model.dart';
import 'package:woundwise/views/settings/todays_appoinment_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<NotificationModel>>(
        future: NotificationFutures.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 180),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.notifications_none, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('No Notifications', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.2), width: 0.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    iconColor: const Color(0xFF1A237E),
                    tileColor: const Color(0xFF1A237E).withOpacity(0.02),
                    leading: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF1A237E).withOpacity(0.1),
                      ),
                      child: const Icon(Icons.calendar_today_rounded),
                    ),
                    title: Text(data[index].title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(data[index].description, style: const TextStyle(fontSize: 12)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TodaysAppointmentScreen()));
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
