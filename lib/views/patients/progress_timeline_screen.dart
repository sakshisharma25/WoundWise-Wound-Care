import 'package:flutter/material.dart';
import 'package:woundwise/future/patient_futures.dart';
import 'package:woundwise/models/progress_timeline_model.dart';


class ProgressTimelineScreen extends StatelessWidget {
  const ProgressTimelineScreen({required this.patientId, super.key});
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Wound Progress Timeline',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: PatientFutures.getWoundProgressTimeline(
            patientId: patientId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: const TextStyle(),
                ),
              );
            }
            final wounds = snapshot.data as List<ProgressTimeLineModel>;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Follow the wound healing progress visually.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: wounds.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _WoundCard(wound: wounds[index]);
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _WoundCard extends StatelessWidget {
  final ProgressTimeLineModel wound;

  const _WoundCard({required this.wound});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    );
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "${wound.updatedAt}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Breadth: ${wound.breadth}', style: textStyle),
                Text('Area: ${wound.area}', style: textStyle),
                Text('Length: ${wound.length}', style: textStyle),
                Text('Depth: ${wound.depth}', style: textStyle),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                (wound.imageUrl == null)
                    ? Container(
                        height: 140,
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      )
                    : Container(
                        height: 140,
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: NetworkImage(wound.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Positioned(
                  // Half of the height of the child Container (30 / 2 = 15)
                  top: -12,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: _iconBgColor(wound.sizeVariation),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _iconData(wound.sizeVariation),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(String? sizeVariation) {
    switch (sizeVariation) {
      case "wound area increased":
        return Icons.arrow_upward;
      case "wound area reduced":
        return Icons.arrow_upward;
      case "wound area same":
        return Icons.arrow_upward;
      case "wound healed":
        return Icons.check_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Color _iconBgColor(String? sizeVariation) {
    switch (sizeVariation) {
      case "wound area increased":
        return Colors.red;
      case "wound area reduced":
        return Colors.green;
      case "wound area same":
        return Colors.yellow;
      case "wound healed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
