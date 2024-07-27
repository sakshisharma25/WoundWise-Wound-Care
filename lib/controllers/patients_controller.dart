import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/patient_information_model.dart';
import 'package:woundwise/models/prescription_model.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/models/analyzed_wound_model.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/api_services.dart';

class PatientsController extends ChangeNotifier {
  final WoundAPIServices apiServices = WoundAPIServices();
  final StorageServices storageService = StorageServices();

  // Patient List
  List<PatientModel> patientsList = [];
  bool isPatientsListLoading = false;

  // Add New Patient
  bool isPatientAddLoading = false;
  bool isPatientAdded = false;

  // Search Patient List
  List<PatientModel> searchPatientList = [];
  bool isSearchListLoading = false;

  // Analyze wound data
  AnalyzedWoundModel? analyzedWoundData;
  bool isWoundDetailsLoading = false;
  String? woundDetectionError;

  // Wound result saved
  bool isWoundResultSaved = false;

  // Generated Prescription
  PrescriptionModel? generatedPrescription;
  bool isGeneratingPrescription = false;

  // Patient Information
  PatientInformationModel? patientInformation;
  bool isPatientInfoLoading = false;
  String? patientInfoError;

  /// Load all patients list
  Future<void> loadPatientsList() async {
    try {
      isPatientsListLoading = true;
      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final email = userData.email;
      if (token == null) {
        throw Exception("Token not found. Please try again");
      }
      if (email == null) {
        throw Exception("Email not found. Please try again");
      }

      final response = await PatientAPIServices.getAllPatientsList(
        token: token,
        email: email,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rowList = data['patient_details'] as List;
        final list =
            rowList.map((patient) => PatientModel.fromJson(patient)).toList();

        patientsList = list.reversed.toList();
        debugPrint("-> Response: $data");
      } else if (response.statusCode == 400) {
        throw Exception("Missing required fields.");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized.");
      } else {
        throw Exception("Internal Server Error. Code: ${response.statusCode}");
      }
    } on Exception catch (exception) {
      kShowSnackBar(exception.toString());
      debugPrint(exception.toString());
    } catch (e) {
      kShowSnackBar("Error loading patients list: $e");
      debugPrint("Error loading patients list: $e");
    } finally {
      isPatientsListLoading = false;
      notifyListeners();
    }
  }

  /// Reset add patient loading states
  void resetAddPatient() {
    isPatientAddLoading = false;
    isPatientAdded = false;
  }

  /// Add new patient and return patient id
  Future<String?> addNewPatient({
    required String? imagePath,
    required String name,
    required String dob,
    required String gender,
    required int age,
    required double height,
    required double weight,
  }) async {
    try {
      isPatientAddLoading = true;
      isPatientAdded = false;
      notifyListeners();

      final doctorData = await StorageServices.getUserData();
      final token = doctorData.token;
      final doctorName = doctorData.name;
      final doctorEmail = doctorData.email;
      final accountType = doctorData.accountType;

      if (token == null) {
        throw "Token not found. Please try again";
      }
      if (doctorName == null) {
        throw "Doctor name not found. Please try again";
      }

      if (doctorEmail == null) {
        throw "Doctor email not found. Please try again";
      }

      if (accountType == null) {
        throw "Account type not found. Please try again";
      }

      final response = await PatientAPIServices.addPatient(
        token: token,
        doctorName: doctorName,
        doctorEmail: doctorEmail,
        name: name,
        dob: dob,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        accountType: accountType,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patientId = data['patient_id'];

        // Upload Image
        if (imagePath != null) {
          await PatientAPIServices.uploadPatientProfilePhoto(
            token: doctorData.token!,
            imagePath: imagePath,
            patientId: patientId,
          );
        }

        kShowSnackBar("Patient added successfully");
        debugPrint("Patient added successfully");
        debugPrint("-> Response: $data");

        isPatientAddLoading = false;
        isPatientAdded = true;
        notifyListeners();

        loadPatientsList();
        return patientId;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized.");
      } else {
        debugPrint("Internal Server Error. ${response.statusCode}");
        throw Exception("Internal Server Error.");
      }
    } catch (error) {
      kShowSnackBar("Error adding patient: $error");
      debugPrint("Error adding patient: $error");
    } finally {
      isPatientAddLoading = false;
      notifyListeners();
    }
    return null;
  }

  /// Search patients by name
  Future<void> searchPatients({required String patientName}) async {
    try {
      searchPatientList = [];
      isSearchListLoading = true;
      final userData = await StorageServices.getUserData();
      final token = userData.token;
      if (token == null) {
        throw Exception("Token not found. Please try again");
      }

      final response = await PatientAPIServices.searchPatient(
        token: token,
        patientName: patientName,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rowList = data['patients'] as List;
        final list =
            rowList.map((patient) => PatientModel.fromJson(patient)).toList();
        searchPatientList = list;
        debugPrint("-> Response: $data");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized.");
      } else {
        throw Exception("Internal Server Error. ${response.statusCode}");
      }
    } catch (e) {
      kShowSnackBar("Error searching patients: $e");
      debugPrint("Error searching patients: $e");
    } finally {
      isSearchListLoading = false;
      notifyListeners();
    }
  }

  /// Analyze wound image and get the details and segmented image
  Future<void> analyzeWound(BuildContext context, String imagePath) async {
    try {
      analyzedWoundData = null;
      isWoundDetailsLoading = true;
      woundDetectionError = null;
      isWoundResultSaved = false; // Reset wound result saved

      final response = await WoundAPIServices.analyzeWound(imagePath);

      if (response.statusCode == 200) {
        final headers = response.headers;
        final bytes = Uint8List.fromList(response.bodyBytes);
        final directory = await getTemporaryDirectory();

        // Format the current date and time
        final now = DateTime.now();
        final formatter = DateFormat('yyyyMMdd_HHmmss');
        final formattedDate = formatter.format(now);

        // Use the formatted date and time in the file name
        final fileName = 'woundImage_$formattedDate.png';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(bytes);

        analyzedWoundData = AnalyzedWoundModel.fromResponse(
          imageFile: file,
          headers: headers,
        );
      } else if (response.statusCode == 500) {
        throw Exception('Wound not detected. Try again with different angle.');
      } else {
        throw Exception('Failed to load the data: ${response.statusCode}');
      }
    } on Exception catch (exception) {
      String msg = exception.toString().replaceFirst("Exception: ", "");
      woundDetectionError = msg;
      debugPrint(msg);
    } catch (e) {
      woundDetectionError = "Error analyzing wound. Try again.";
      kShowSnackBar("Error analyzing wound: $e");
      debugPrint("Error analyzing wound: $e");
    } finally {
      isWoundDetailsLoading = false;
      notifyListeners();
    }
  }

  /// Save wound details and image for the patient
  Future<void> saveWoundDetails({
    required String realImagePath,
    required String apiImagePath,
    required double lengthCm,
    required double breadthCm,
    required double depthCm,
    required double areaCm2,
    required String moisture,
    required String woundLocation,
    required String tissue,
    required String exudate,
    required String periwound,
    required String periwoundType,
    required String patientId,
    required String type,
    required String category,
    required String edge,
    required String infection,
    required String lastDressingDate,
  }) async {
    try {
      isWoundResultSaved = false;

      final userData = await StorageServices.getUserData();
      final token = userData.token;
      if (token == null) {
        throw Exception("Token not found. Please try again");
      }

      final response = await WoundAPIServices.saveWoundDetails(
        token: token,
        realImagePath: realImagePath,
        apiImagePath: apiImagePath,
        length: lengthCm,
        breadth: breadthCm,
        depth: depthCm,
        area: areaCm2,
        moisture: moisture,
        woundLocation: woundLocation,
        tissue: tissue,
        exudate: exudate,
        periwound: periwound,
        periwoundType: periwoundType,
        patientId: patientId,
        type: type,
        category: category,
        edge: edge,
        infection: infection,
        lastDressingDate: lastDressingDate,
      );

      debugPrint("-> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        kShowSnackBar("Wound details saved successfully");
        debugPrint("Wound details saved successfully");
        isWoundResultSaved = true;
        notifyListeners();
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized.");
      } else {
        throw Exception("Internal Server Error. ${response.statusCode}");
      }

      // _saveWoundImage(imagePath: imagePath, patientId: patientId);
    } catch (e) {
      kShowSnackBar("Error saving wound details: $e");
      debugPrint("Error saving wound details: $e");
    }
  }
}
