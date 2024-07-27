class PatientInformationModel {
  String? patientId;
  String? registerDate;
  String? name;
  int? age;
  String? gender;
  String? dob;
  String? allergies;
  String? pastHistory;
  String? doctorName;
  String? careFacilities;
  String? woundLocation;

  PatientInformationModel({
    required this.patientId,
    required this.registerDate,
    required this.name,
    required this.age,
    required this.gender,
    required this.dob,
    required this.allergies,
    required this.pastHistory,
    required this.doctorName,
    required this.careFacilities,
    required this.woundLocation,
  });

  factory PatientInformationModel.fromJson(Map<String, dynamic> json) {
    var woundLocation = '';
    if (json['wound_details'] != null && json['wound_details'].isNotEmpty) {
      var firstWoundDetail = json['wound_details'][0];
      woundLocation = firstWoundDetail['wound_location']?.toString() ?? '';
    }

    return PatientInformationModel(
      patientId: json['patient_id'],
      registerDate: json['register_date'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      dob: json['dob'],
      allergies: json['allergies'],
      pastHistory: json['past_history'],
      doctorName: json['doctor_name'],
      careFacilities: json['care_facilities'],
      woundLocation: woundLocation.toString(),
    );
  }
}
