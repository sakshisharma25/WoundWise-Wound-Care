import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:woundwise/future/analysis_futures.dart';
import 'package:woundwise/models/noofappointment_mode.dart';

class AppointmentsGraph extends StatelessWidget {
  const AppointmentsGraph({required this.unqicKey, super.key});
  final UniqueKey unqicKey;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: unqicKey,
      future: AnalysisFutures.getAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 248,
            child: Center(
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(height: 248, child: Center(child: Text("${snapshot.error}")));
        } else {
          final appointmentList = snapshot.data as List<NoOfAppointmentModel>;
          if (appointmentList.isEmpty) {
            return Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Column(
                children: [
                  Icon(Icons.line_weight_sharp, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No Patients Found',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          return _AppointmentGraphWidget(appointmentList);
        }
      },
    );
  }
}

class _AppointmentGraphWidget extends StatelessWidget {
  const _AppointmentGraphWidget(this.appointmentList);
  final List<NoOfAppointmentModel> appointmentList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(20),
      height: 210,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(LineChartData(
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        gridData: const FlGridData(
          show: true,
          drawHorizontalLine: false,
          drawVerticalLine: true,
          verticalInterval: 1,
        ),
        lineBarsData: [
          LineChartBarData(
            show: true,
            spots: (appointmentList.isNotEmpty)
                ? appointmentList
                    .map((e) => FlSpot(appointmentList.indexOf(e).toDouble(), e.totalAppointments.toDouble()))
                    .toList()
                : [
                    const FlSpot(0, 0),
                    const FlSpot(1, 0),
                    const FlSpot(2, 0),
                    const FlSpot(3, 0),
                    const FlSpot(4, 0),
                    const FlSpot(5, 0),
                    const FlSpot(6, 0),
                  ],
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                if (spot.x == 6) {
                  return true;
                }
                return false;
              },
              getDotPainter: (p0, p1, p2, p3) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  appointmentList[value.toInt()].date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  touchedSpot.y.toString(),
                  const TextStyle(color: Colors.white, fontSize: 14),
                );
              }).toList();
            },
          ),
        ),
      )),
    );
  }
}
