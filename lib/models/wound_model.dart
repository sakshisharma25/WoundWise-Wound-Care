class WoundModel {
  String id;
  double height;
  double width;
  double depth;
  double area;
  String moisture;
  String position;
  String tissue;
  String exudate;
  String periwound;
  String periwoundType;
  String patientId;

  WoundModel({
    required this.id,
    required this.height,
    required this.width,
    required this.depth,
    required this.area,
    required this.moisture,
    required this.position,
    required this.tissue,
    required this.exudate,
    required this.periwound,
    required this.periwoundType,
    required this.patientId,
  });

  factory WoundModel.fromJson(Map<String, dynamic> json) {
    return WoundModel(
      id: json['id'],
      height: double.tryParse(json['height'] ?? '0.0') ?? 0.0,
      width: double.tryParse(json['width'] ?? '0.0') ?? 0.0,
      depth: double.tryParse(json['depth'] ?? '0.0') ?? 0.0,
      area: double.tryParse(json['area'] ?? '0.0') ?? 0.0,
      moisture: json['moisture'],
      position: json['position'],
      tissue: json['tissue'],
      exudate: json['exudate'],
      periwound: json['periwound'],
      periwoundType: json['periwound_type'],
      patientId: json['patient_id'],
    );
  }
}
