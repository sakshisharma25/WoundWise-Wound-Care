class MedicationModel {
  String id;
  String medicationName;
  String dosage;
  String frequency;
  String duration;
  String woundType;
  String dimension;

  MedicationModel({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.woundType,
    required this.dimension,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      medicationName: json['medication_name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      woundType: json['woundType'],
      dimension: json['dimension'],
    );
  }
}
