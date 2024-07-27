class PatientModel {
  final String? profileImageUrl;
  final String? profileImagePath;
  final String? id;
  final String? name;
  final String? dob;
  final String? gender;
  final String? age;
  final String? height;
  final String? weight;

  PatientModel({
    required this.profileImageUrl,
    required this.profileImagePath,
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory PatientModel.fromJson(Map<String, dynamic> map) {
    return PatientModel(
      profileImageUrl: map['profile_photo_path'],
      profileImagePath: null,
      id: "${map['patient_id']}",
      name: "${map['name']}",
      dob: "${map['dob']}",
      gender: "${map['gender']}",
      age: "${map['age']}",
      height: "${map['height']}",
      weight: "${map['weight']}",
    );
  }
}
