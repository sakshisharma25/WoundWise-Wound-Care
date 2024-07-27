// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/services/api_services.dart';
import 'dart:convert';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/dashboard/dashboard_screen.dart';

class OrganizationInfoScreen extends StatefulWidget {
  const OrganizationInfoScreen({super.key});

  @override
  State<OrganizationInfoScreen> createState() => _OrganizationInfoScreenState();
}

class _OrganizationInfoScreenState extends State<OrganizationInfoScreen> {
  final TextEditingController _locationController = TextEditingController();
  final ValueNotifier<List<String>> _selectedWards = ValueNotifier([]);
  bool _isLoading = false;

  void _onSavePressed() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final email = userData.email;

      if (token == null) {
        throw 'Token not found. Try again.';
      }

      if (email == null) {
        throw 'Email not found. Try again.';
      }

      final department = _selectedWards.value.join(', ');
      final location = _locationController.text;

      if (department.isEmpty || location.isEmpty) {
        throw 'Please fill all the fields correctly.';
      }

      final response = await OrganizationAPIServices.saveAdditionalData(
        token: token,
        department: department,
        location: location,
        email: email,
      );

      debugPrint("->${response.body}");
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const DashboardScreen(accountType: AccountType.organization),
            settings: const RouteSettings(name: "DashboardScreen"),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        final data = jsonDecode(response.body);
        throw "${data['error']}";
      } else {
        throw 'Internal server error. ${response.statusCode}';
      }
    } catch (error) {
      kShowSnackBar("$error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/logo1.png', height: 70),
                        const SizedBox(height: 20),
                        const Text(
                          'Organization Info',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildReadOnlyField('Category'),
                  _buildSelectWardSection(),
                  _buildTextField(
                    'Location',
                    _locationController,
                    'Enter Location Manually',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: const TextStyle(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
          keyboardType: label == 'Mobile Number'
              ? TextInputType.phone
              : TextInputType.text,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildReadOnlyField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: TextEditingController(text: 'Hospital'),
          style: const TextStyle(),
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
          ),
          enabled: false,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSelectWardSection() {
    return ValueListenableBuilder(
        valueListenable: _selectedWards,
        builder: (context, list, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Geriatric Ward - G3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: list
                    .map(
                      (ward) => Chip(
                        color: WidgetStatePropertyAll(Colors.grey.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        label: Text(
                          ward,
                          style: const TextStyle(),
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedWards.value.remove(ward);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  'Add More',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: _openDepartmentSelection,
                style: TextButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),
              const SizedBox(height: 20),
            ],
          );
        });
  }

  void _openDepartmentSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentSelectionScreen(
          selectedDepartments: _selectedWards,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 18),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: _onSavePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DepartmentSelectionScreen extends StatefulWidget {
  final ValueNotifier<List<String>> selectedDepartments;

  // Add 'required' keyword to ensure these parameters must be provided
  const DepartmentSelectionScreen(
      {super.key, required this.selectedDepartments});

  @override
  State<DepartmentSelectionScreen> createState() =>
      _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  List<String> _selectedDepartments = [];

  @override
  void initState() {
    super.initState();
    _selectedDepartments = List.from(widget.selectedDepartments.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Select Departments',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.selectedDepartments.value = _selectedDepartments;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          'Emergency ICU',
          'Wound Healing',
          'Oncology',
          'Cardiology',
          'Orthopedic',
          'Gastroenterology',
          'Pulmonology',
          'Neurology',
          'Urology',
          'Pediatrics'
        ].map((dept) {
          final isSelected = _selectedDepartments.contains(dept);
          return ListTile(
            title: Text(
              dept,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.check_circle_outline,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            onTap: () {
              setState(() {
                if (_selectedDepartments.contains(dept)) {
                  _selectedDepartments.remove(dept);
                } else {
                  _selectedDepartments.add(dept);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
