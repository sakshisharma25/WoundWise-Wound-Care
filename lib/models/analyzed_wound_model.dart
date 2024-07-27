import 'dart:io';

class AnalyzedWoundModel {
  final File imageFile;
  final double areaCm2;
  final double breadthCm;
  final double depthCm;
  final double lengthCm;
  final double moisture;

  AnalyzedWoundModel({
    required this.imageFile,
    required this.areaCm2,
    required this.breadthCm,
    required this.depthCm,
    required this.lengthCm,
    required this.moisture,
  });

  factory AnalyzedWoundModel.fromResponse({
    required File imageFile,
    required Map<String, String> headers,
  }) {
    return AnalyzedWoundModel(
      imageFile: imageFile,
      areaCm2: double.tryParse(headers['x-area-cm2'] ?? "0.0") ?? 0.0,
      breadthCm: double.tryParse(headers['x-breadth-cm'] ?? "0.0") ?? 0.0,
      depthCm: double.tryParse(headers['x-depth-cm'] ?? "0.0") ?? 0.0,
      lengthCm: double.tryParse(headers['x-length-cm'] ?? "0.0") ?? 0.0,
      moisture: double.tryParse(headers['x-moisture'] ?? "0.0") ?? 0.0,
    );
  }
}
