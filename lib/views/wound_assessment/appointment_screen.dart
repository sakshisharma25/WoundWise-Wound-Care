import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedDate = DateTime.now();

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Widget buildCalendar(DateTime initialDate) {
    DateTime firstDayOfMonth = DateTime(initialDate.year, initialDate.month, 1);
    DateTime lastDayOfMonth = DateTime(initialDate.year, initialDate.month + 1, 0);

    return CalendarDatePicker(
      initialDate: firstDayOfMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      currentDate:
          _selectedDate.isAfter(firstDayOfMonth) && _selectedDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)))
              ? _selectedDate
              : null,
      onDateChanged: _onDateChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vertical Scrolling Calendar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                DateTime currentMonth = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + index,
                  1,
                );

                return Column(
                  children: [
                    buildCalendar(currentMonth),
                    const SizedBox(height: 20.0),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
