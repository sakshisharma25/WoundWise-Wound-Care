import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class MedicationPDFScreen extends StatelessWidget {
  const MedicationPDFScreen({required this.asset, super.key});
  final String asset;

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade200,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Medication Mapping', style: titleStyle),
      ),
      body: SfPdfViewer.asset(
        "assets/pdf/medication_mapping.pdf",
        canShowPageLoadingIndicator: true,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
