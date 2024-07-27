import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/other/human_body_screen.dart';
import 'package:woundwise/views/patients/patient_info_screen.dart';
import 'package:woundwise/views/patients/add_patient_screen.dart';
import 'package:woundwise/views/wound_assessment/select_patient_type_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.accountType, super.key});
  final AccountType accountType;

  @override
  State<HomeScreen> createState() => _HomeOrgPageState();
}

class _HomeOrgPageState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<PatientsController>().loadPatientsList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/background_image11.png",
            fit: BoxFit.cover,
          ),
        ),
        RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2), () {
              return context.read<PatientsController>().loadPatientsList();
            });
          },
          color: Colors.blue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SelectPatientTypeScreen(
                                aimOfClick: AimOfClick.takePicture,
                              ),
                            ),
                          );
                        },
                        child: _buildActionCard(
                          'assets/camera_icon.png',
                          'Take a Picture',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SelectPatientTypeScreen(
                                aimOfClick: AimOfClick.uploadPicture,
                              ),
                            ),
                          );
                        },
                        child: _buildActionCard(
                          'assets/upload_icon.png',
                          'Upload Picture',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 6,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HumanBodyScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '360 View \nHuman Body',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Click to View',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Image.asset(
                              'assets/human_body.png',
                              width: 115,
                              height: 115,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          "Patient's List",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddPatientScreen(
                                aimOfClick: AimOfClick.savePatient,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 2,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(26, 35, 126, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '+  Add',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ), // Smaller text size
                      ),
                    ],
                  ),
                ),
                Consumer<PatientsController>(
                  builder: (context, controller, _) {
                    final isLoading = controller.isPatientsListLoading;
                    final list = controller.patientsList;

                    if (isLoading) {
                      return Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const Column(
                          children: [
                            Icon(Icons.line_weight_sharp,
                                size: 60, color: Colors.grey),
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
                                builder: (context) =>
                                    PatientInfoScreen(patient: list[index]),
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
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String imagePath, String label) {
    return Container(
      width: 170,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 36,
            height: 36,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
