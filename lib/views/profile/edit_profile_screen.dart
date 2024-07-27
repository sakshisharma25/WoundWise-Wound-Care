// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/account_preference_model.dart';
import 'package:woundwise/models/profile_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/register/organization_info_screen.dart';

const kDepatmentNames = [
  'Emergency ICU',
  'Wound Healing',
  'Oncology',
  'Cardiology',
  'Orthopedic',
  'Gastroenterology',
  'Pulmonology',
  'Neurology',
  'Urology',
  'Pediatrics',
];

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.profile, super.key});
  final ProfileModel profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController aboutController;
  late TextEditingController locationController;
  final ValueNotifier<List<String>> department = ValueNotifier([]);
  File? pickedImage;
  bool isSaving = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.profile.name);
    department.value = widget.profile.departments?.split(',') ?? [];
    aboutController = TextEditingController(text: widget.profile.about);
    locationController = TextEditingController(text: widget.profile.location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 15);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _ProfilePicture(
                    localImagePath: pickedImage?.path,
                    profileImageUrl: widget.profile.profileImageUrl,
                  ),
                  TextButton(
                    onPressed: () => _pickImageFromGallery(),
                    child: const Text(
                      'Change Profile Picture',
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: nameController,
                      style: textStyle,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        hintText: 'Enter name',
                        hintStyle: textStyle,
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]')),
                      ],
                      onTapOutside: (focusNode) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SelectDepartment(selectedWards: department),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      style: textStyle,
                      controller: aboutController,
                      decoration: InputDecoration(
                        labelText: 'About',
                        labelStyle: textStyle,
                        hintText: 'Enter about',
                        hintStyle: textStyle,
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      minLines: 2,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: locationController,
                      style: textStyle,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        labelStyle: textStyle,
                        hintText: 'Enter location',
                        hintStyle: textStyle,
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.done,
                      onTapOutside: (focusNode) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  _SaveButton(
                    onPressed: () => _saveProfile(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isSaving)
            Container(
              color: Colors.white.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      // bottomNavigationBar: _SaveButton(
      //   onPressed: () => _saveProfile(),
      // ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      final pickedImageFile = File(image.path);
      setState(() {
        pickedImage = pickedImageFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (isSaving) return;
    try {
      setState(() {
        isSaving = true;
      });

      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final userEmail = userData.email;
      final accountType = userData.accountType;

      if (token == null) {
        throw 'Token is not available';
      }

      if (userEmail == null) {
        throw 'Email is not available';
      }

      if (accountType == null) {
        throw 'Account type is not available';
      }

      await _uploadUserProfilePhoto(
        email: userEmail,
        accountType: accountType,
      );

      await _updateDetails(
        token: token,
        accountType: accountType,
        email: userEmail,
      );
    } catch (error) {
      kShowSnackBar("$error");
      debugPrint("Failed to update profile picture: $error");
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<void> _uploadUserProfilePhoto(
      {required String email, required AccountType accountType}) async {
    if (pickedImage != null) {
      Response response;
      if (accountType == AccountType.practitioner) {
        response = await PractitionerAPIServices.storeProfilePicture(
          imagePath: pickedImage!.path,
          userEmail: email,
        );
      } else {
        response = await OrganizationAPIServices.storeProfilePicture(
          imagePath: pickedImage!.path,
          userEmail: email,
        );
      }
      if (response.statusCode == 200) {
        kShowSnackBar("Profile picture updated successfully.");
      } else {
        throw 'Internal server error: ${response.statusCode}';
      }
    }
  }

  Future<void> _updateDetails({
    required String token,
    required AccountType accountType,
    required String email,
  }) async {
    Response response;

    if (accountType == AccountType.practitioner) {
      response = await PractitionerAPIServices.updateProfile(
        token: token,
        name: nameController.text,
        department: department.value.join(","),
        about: aboutController.text,
        location: locationController.text,
        latitude: "0.0",
        longitude: "0.0",
        email: email,
      );
    } else {
      response = await OrganizationAPIServices.updateProfile(
        token: token,
        name: nameController.text,
        department: department.value.join(","),
        about: aboutController.text,
        location: locationController.text,
        latitude: "0.0",
        longitude: "0.0",
        email: email,
      );
    }

    if (response.statusCode == 200) {
      kShowSnackBar("Profile updated successfully.");
      _updateProfileInSharedPreference();
      // Refresh the profile screen
      Navigator.pop(context, true);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      throw data['error'];
    } else {
      throw 'Internal server error: ${response.statusCode}';
    }
  }

  /// Update profile locally
  Future<void> _updateProfileInSharedPreference() async {
    final AccountPreferenceModel accountPreference = AccountPreferenceModel(
      name: nameController.text,
    );
    await StorageServices.setUserData(accountPreference);
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture(
      {required this.localImagePath, required this.profileImageUrl});
  final String? localImagePath;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: (localImagePath != null)
            ? Image.file(
                File(localImagePath!),
                fit: BoxFit.cover,
              )
            : (profileImageUrl != null)
                ? CachedNetworkImage(
                    imageUrl: profileImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildDemoPicture(),
                    errorWidget: (context, url, error) => _buildDemoPicture(),
                  )
                : _buildDemoPicture(),
      ),
    );
  }

  Widget _buildDemoPicture() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SelectDepartment extends StatelessWidget {
  const _SelectDepartment({required this.selectedWards});
  final ValueNotifier<List<String>> selectedWards;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedWards,
        builder: (context, list, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Departments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8, width: double.infinity),
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
                          selectedWards.value.remove(ward);
                          selectedWards.notifyListeners();
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentSelectionScreen(
                        selectedDepartments: selectedWards,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),
              const SizedBox(height: 20),
            ],
          );
        });
  }
}
