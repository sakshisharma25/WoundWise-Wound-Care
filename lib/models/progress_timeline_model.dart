class ProgressTimeLineModel {
  final String? imageUrl;
  final String? updatedAt;
  final String? area;
  final String? depth;
  final String? length;
  final String? patientId;
  final String? sizeVariation;
  final String? breadth;

  ProgressTimeLineModel({
    required this.imageUrl,
    required this.updatedAt,
    required this.area,
    required this.depth,
    required this.length,
    required this.patientId,
    required this.sizeVariation,
    required this.breadth,
  });

  factory ProgressTimeLineModel.fromJson(Map<String, dynamic> json) {
    return ProgressTimeLineModel(
      imageUrl: json['image'],
      updatedAt: json['updated_at'],
      area: json['area'],
      depth: json['depth'],
      length: json['length'],
      patientId: json['patient_id'],
      sizeVariation: json['size_variation'],
      breadth: json['breadth'],
    );
  }
}
