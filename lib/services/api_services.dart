import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:woundwise/constants.dart';

const String kBaseUrl = 'https://woundwiseapi.eplisio.com';

class PractitionerAPIServices {
  static Future<http.Response> sendEmail({
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/med_send_email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'c_code': countryCode,
        'phone': phoneNumber,
      }),
    );
  }

  static Future<http.Response> createPinAndSaveData({
    required String name,
    required String email,
    required String countryCode,
    required String phone,
    required String licenseKey,
    required String pin,
  }) {
    const url = '$kBaseUrl/med_create_pin';
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'c_code': countryCode,
        'phone': phone,
        'license_key': licenseKey,
        'pin': pin,
      }),
    );
  }

  static Future<http.Response> sendOTP({required String phone}) {
    return http.post(
      Uri.parse('$kBaseUrl/med_send_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
  }

  static Future<http.Response> storeProfilePicture({
    required String imagePath,
    required String userEmail,
  }) async {
    var uri = Uri.parse('$kBaseUrl/store_med_image');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': 'application/json', 'Content-Type': 'multipart/form-data'})
      ..fields['email'] = userEmail
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));
    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> fetchProfileDetails({
    required String userEmail,
    required String token,
  }) async {
    var uri = Uri.parse('$kBaseUrl/med_details');
    var request = http.Request('GET', uri);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    request.body = jsonEncode({'email': userEmail});
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> updateProfile({
    required String token,
    required String name,
    required String department,
    required String about,
    required String location,
    required String latitude,
    required String longitude,
    required String email,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/update_med_profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'department': department,
        'about': about,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'email': email,
      }),
    );
  }

  static Future<http.Response> changePIN({
    required String token,
    required String email,
    required String currentPin,
    required String newPin,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/change_pin_med'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'current_pin': currentPin,
        'new_pin': newPin,
      }),
    );
  }

  static Future<http.Response> sendOTPToForgetPIN({required String token, required String phone}) {
    return http.post(
      Uri.parse('$kBaseUrl/med/forgot/pin/otp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'phone': phone}),
    );
  }

  static Future<http.Response> forgetPIN({
    required String token,
    required String email,
    required String otp,
    required String newPin,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/forgot_pin_med'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'new_pin': newPin,
      }),
    );
  }
}

class OrganizationAPIServices {
  static Future<http.Response> sendEmail({
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/send_email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'c_code': countryCode,
        'phone': phoneNumber,
      }),
    );
  }

  static Future<http.Response> createPinAndSaveData({
    required String name,
    required String email,
    required String countryCode,
    required String phone,
    required String licenseKey,
    required String pin,
  }) {
    const url = '$kBaseUrl/create_pin';
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'c_code': countryCode,
        'phone': phone,
        'license_key': licenseKey,
        'pin': pin,
      }),
    );
  }

  static Future<http.Response> saveAdditionalData({
    required String token,
    required String department,
    required String location,
    required String email,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/save_additional_data'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'department': department,
        'location': location,
        'email': email,
        'latitude': "0.0",
        'longitude': "0.0",
      }),
    );
  }

  static Future<http.Response> sendOTP({required String phone}) {
    return http.post(
      Uri.parse('$kBaseUrl/send_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
  }

  static Future<http.Response> storeProfilePicture({
    required String imagePath,
    required String userEmail,
  }) async {
    var uri = Uri.parse('$kBaseUrl/store_org_image');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'accept': 'application/json', 'Content-Type': 'multipart/form-data'})
      ..fields['email'] = userEmail
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));
    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> fetchProfileDetails({
    required String userEmail,
    required String token,
  }) async {
    var uri = Uri.parse('$kBaseUrl/organisation_details');
    var request = http.Request('GET', uri);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    request.body = jsonEncode({'email': userEmail});
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> adminAddPractitioner({
    required String token,
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String organizationEmail,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/admin_add_practitioner_v2'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'c_code': countryCode,
        'phone': phoneNumber,
        'org_email': organizationEmail,
      }),
    );
  }

  static Future<http.Response> updateProfile({
    required String token,
    required String name,
    required String department,
    required String about,
    required String location,
    required String latitude,
    required String longitude,
    required String email,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/update_org_profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'department': department,
        'about': about,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'email': email,
      }),
    );
  }

  static Future<http.Response> changePIN({
    required String token,
    required String email,
    required String currentPin,
    required String newPin,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/change_pin_org'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'current_pin': currentPin,
        'new_pin': newPin,
      }),
    );
  }

  static Future<http.Response> sendOTPToForgetPIN({required String token, required String phone}) {
    return http.post(
      Uri.parse('$kBaseUrl/org/forgot/pin/otp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'phone': phone}),
    );
  }

  static Future<http.Response> forgetPIN({
    required String token,
    required String email,
    required String otp,
    required String newPin,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/forgot_pin_org'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'new_pin': newPin,
      }),
    );
  }
}

class PatientAPIServices {
  static Future<http.Response> getAllPatientsList({
    required String token,
    required String email,
  }) async {
    final uri = Uri.parse('$kBaseUrl/get_all_patient_details');
    var request = http.Request('GET', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({'email': email});
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> addPatient({
    required String token,
    required String name,
    required String dob,
    required String gender,
    required int age,
    required double height,
    required double weight,
    required String doctorName,
    required String doctorEmail,
    required AccountType accountType,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/add_patient_v2'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": name,
        "dob": dob,
        "gender": gender,
        "age": age,
        "height": height,
        "weight": weight,
        "email": doctorEmail,
        "doctor": doctorName,
        "role": (accountType == AccountType.practitioner) ? "3" : "5",
      }),
    );
  }

  static Future<http.Response> uploadPatientProfilePhoto({
    required String token,
    required String imagePath,
    required String patientId,
  }) async {
    var uri = Uri.parse("$kBaseUrl/store_image");
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
      })
      ..fields['patient_id'] = patientId
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> searchPatient({required String token, required String patientName}) {
    return http.post(
      Uri.parse('$kBaseUrl/search_patient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': patientName,
      }),
    );
  }

  static Future<http.Response> getInformations({
    required String token,
    required String patientId,
  }) async {
    final uri = Uri.parse('$kBaseUrl/patient_details');
    var request = http.Request('GET', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({'patient_id': patientId});
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> updateDetails({
    required String patientId,
    required String allergies,
    required String pastHistory,
    required String doctorName,
    required String careFacilities,
    required String token,
  }) async {
    const url = '$kBaseUrl/update_patient_details';
    var uri = Uri.parse(url);
    var request = http.Request('POST', uri);
    request.headers.addAll({'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});
    request.body = jsonEncode({
      'patient_id': patientId,
      'allergies': allergies,
      'past_history': pastHistory,
      'doctor_name': doctorName,
      'care_facilities': careFacilities,
    });
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> getProgressTimeline({
    required String token,
    required String patientId,
  }) async {
    final uri = Uri.parse('$kBaseUrl/wound_progress_timeline');
    var request = http.Request('GET', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({'patient_id': patientId});
    final response = await request.send();
    return http.Response.fromStream(response);
  }
}

class WoundAPIServices {
  static Future<http.Response> analyzeWound(String imagePath) async {
    const url = 'https://woundwisewound.eplisio.com/analyze_wound';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({'accept': 'application/json', 'Content-Type': 'multipart/form-data'});

    final file = await http.MultipartFile.fromPath('file', imagePath, contentType: MediaType('image', 'jpeg'));

    request.files.add(file);

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> saveWoundDetails({
    required String realImagePath,
    required String apiImagePath,
    required String token,
    required double length,
    required double breadth,
    required double depth,
    required double area,
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
    var uri = Uri.parse('$kBaseUrl/add_wound_details_v3');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..fields['length'] = length.toStringAsFixed(2)
      ..fields['breadth'] = breadth.toStringAsFixed(2)
      ..fields['depth'] = depth.toStringAsFixed(2)
      ..fields['area'] = area.toStringAsFixed(2)
      ..fields['moisture'] = moisture
      ..fields['wound_location'] = woundLocation
      ..fields['tissue'] = tissue
      ..fields['exudate'] = exudate
      ..fields['periwound'] = periwound
      ..fields['periwound_type'] = periwoundType
      ..fields['patient_id'] = patientId
      ..fields['type'] = type
      ..fields['category'] = category
      ..fields['edge'] = edge
      ..fields['infection'] = infection
      ..fields['last_dressing_date'] = lastDressingDate
      ..files.add(await http.MultipartFile.fromPath('image', realImagePath))
      ..files.add(await http.MultipartFile.fromPath('api_image', apiImagePath));
    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> updateScheduledDate({
    required String token,
    required String userEmail,
    required String patientId,
    required String scheduledDate,
  }) async {
    return http.post(
      Uri.parse('$kBaseUrl/update_scheduled_date_v2'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': userEmail,
        'patient_id': patientId,
        'scheduled_date': scheduledDate,
      }),
    );
  }

  static Future<http.Response> saveNotes({
    required String token,
    required String patientId,
    required String notes,
    required String remarks,
  }) {
    return http.post(
      Uri.parse('$kBaseUrl/save_notes_v2'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'patient_id': patientId,
        'notes': notes,
        'remarks': remarks,
      }),
    );
  }

  static Future<http.Response> totalAppointments({
    required String token,
    required String startDate,
    required String endDate,
    required String userEmail,
  }) async {
    final uri = Uri.parse('$kBaseUrl/total_appointments_v2');
    var request = http.Request('GET', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({
        'start_date': startDate,
        'end_date': endDate,
        'email': userEmail,
      });
    final response = await request.send();
    return http.Response.fromStream(response);
  }
}

class NotificationAPIServices {
  static Future<http.Response> fetchNotifications({
    required String token,
    required String email,
    required String date,
  }) async {
    final uri = Uri.parse('$kBaseUrl/get_appointment_count');
    var request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({
        'email': email,
        'date': date,
      });
    final response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> getTodaysAppointments({
    required String token,
    required String email,
    required String date,
  }) async {
    final uri = Uri.parse('$kBaseUrl/sort_patients');
    var request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({
        'email': email,
        'date': date,
      });
    final response = await request.send();
    return http.Response.fromStream(response);
  }
}
