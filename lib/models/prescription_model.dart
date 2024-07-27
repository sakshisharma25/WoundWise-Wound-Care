import 'package:woundwise/models/medication_model.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/models/wound_model.dart';

class PrescriptionModel {
  PatientModel patientDetails;
  List<WoundModel> woundDetails;
  List<MedicationModel> medicationDetails;

  PrescriptionModel({
    required this.patientDetails,
    required this.woundDetails,
    required this.medicationDetails,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    final data = json['prescription'];
    return PrescriptionModel(
      patientDetails: PatientModel.fromJson(data['patient_details']),
      woundDetails: List<WoundModel>.from(data['wound_details'].map((x) => WoundModel.fromJson(x))),
      medicationDetails: List<MedicationModel>.from(data['medication_details'].map((x) => MedicationModel.fromJson(x))),
    );
  }
}
