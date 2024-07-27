// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/wound_assessment/followup_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrescriptionPDFScreen extends StatefulWidget {
  const PrescriptionPDFScreen({
    required this.patientData,
    required this.woundType,
    required this.causeOfWound,
    required this.woundLocation,
    required this.areaOfWound,
    required this.recommendation,
    required this.remarks,
    super.key,
  });
  final PatientModel patientData;
  final String woundType;
  final String? causeOfWound;
  final String? woundLocation;
  final String? areaOfWound;
  final String recommendation;
  final String remarks;

  @override
  State<PrescriptionPDFScreen> createState() => _PrescriptionPDFScreenState();
}

class _PrescriptionPDFScreenState extends State<PrescriptionPDFScreen> {
  final ValueNotifier<String> doctorName = ValueNotifier('');
  final ValueNotifier<String> doctorNumber = ValueNotifier('');
  final ValueNotifier<String> date = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final doctorInfo = await StorageServices.getUserData();
      doctorName.value = doctorInfo.name.toString();
      doctorNumber.value = doctorInfo.phoneNumber.toString();
      date.value = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    } catch (e) {
      debugPrint('Error: $e');
      Navigator.pop(context);
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final woundwiseLogo = await rootBundle.load('assets/logo.png');
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(
                      (woundwiseLogo).buffer.asUint8List(),
                    ),
                    height: 40,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        doctorName.value,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text('Mobile: ${doctorNumber.value}'),
                      pw.Text('Date: ${date.value}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Patient Name: ${widget.patientData.name}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.Text('Patient ID: ${widget.patientData.id}'),
              pw.Text('Gender: ${widget.patientData.gender}'),
              pw.Text('Age: ${widget.patientData.age}'),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(4),
                },
                children: [
                  _buildTableRow('Current Diagnosis', widget.woundType),
                  _buildTableRow('Cause of Wound', widget.causeOfWound ?? ''),
                  _buildTableRow('Wound Location', widget.woundLocation ?? ''),
                  _buildTableRow('Area of Wound', widget.areaOfWound ?? ''),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableRow('Recommendations:', 'Remarks:'),
                  _buildTableRow(widget.recommendation, widget.remarks),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                      pw.Text('Review Date'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(doctorName.value),
                      pw.Text('Signature'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.TableRow _buildTableRow(String title, String value) {
    return pw.TableRow(
      children: [
        _buildTableCell(title),
        _buildTableCell(value),
      ],
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Prescription',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              generatePdf();
            },
          ),
        ],
      ),
      body: Consumer<PatientsController>(
        builder: (context, controller, _) {
          if (controller.isGeneratingPrescription) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo.png', // Add your logo asset path
                        height: 40,
                        fit: BoxFit.fitHeight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: doctorName,
                            builder: (context, value, child) => Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: doctorNumber,
                            builder: (context, value, child) => Text(
                              'Mobile: $value',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: date,
                            builder: (context, value, child) => Text(
                              'Date: $value',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Patient Name: ${widget.patientData.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Patient ID: ${widget.patientData.id}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Gender: ${widget.patientData.gender}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Age: ${widget.patientData.age}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(4),
                    },
                    children: [
                      _buildRow('Current Diagnosis:', widget.woundType),
                      _buildRow('Cause of Wound:', widget.causeOfWound ?? ''),
                      _buildRow('Wound Location:', widget.woundLocation ?? ''),
                      _buildRow('Area of Wound:', widget.areaOfWound ?? ''),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      _buildRow(
                        'Recommendations:',
                        'Remarks:',
                      ),
                      _buildRow(
                        widget.recommendation,
                        widget.remarks,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd-MM-yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Review Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: doctorName,
                        builder: (context, value, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Signature',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildNavigationButton(context),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FollowUpScreen(patientData: widget.patientData),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(String title, String value) {
    return TableRow(
      children: [
        _buildCell(title),
        _buildCell(value),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
