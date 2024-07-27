import 'package:flutter/material.dart';
import 'package:woundwise/future/notification_futures.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/patients/patient_info_screen.dart';


class TodaysAppointmentScreen extends StatelessWidget {
  const TodaysAppointmentScreen({super.key});

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
          'Today\'s Appointments',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder(
        future: NotificationFutures.getTodaysAppointments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data!;
            if (list.isEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 180),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.line_weight_sharp, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('No Appointments', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientInfoScreen(patient: list[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: PatientTile(
                      patientData: list[index],
                      showViewButton: true,
                      showSelectButton: false,
                    ),
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