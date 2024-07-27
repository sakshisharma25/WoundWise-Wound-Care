// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/views/wound_assessment/wound_result_screen.dart';

class OpenCameraScreen extends StatefulWidget {
  const OpenCameraScreen({required this.patientData, super.key});
  final PatientModel patientData;

  @override
  State<OpenCameraScreen> createState() => _OpenCameraScreenState();
}

class _OpenCameraScreenState extends State<OpenCameraScreen> {
  final ValueNotifier<PermissionStatus> _permissionStatus =
      ValueNotifier<PermissionStatus>(PermissionStatus.denied);
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _checkPermission();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.first, ResolutionPreset.high);
        _initializeControllerFuture = _controller.initialize();
        await _initializeControllerFuture;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        throw CameraException('NoCamera', 'No camera available');
      }
    } catch (e) {
      kShowSnackBar("Camera initialization failed: $e");
    }
  }

  void _checkPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    _permissionStatus.value = status;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Take a picture',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _permissionStatus,
          builder: (context, PermissionStatus status, _) {
            if (status == PermissionStatus.denied) {
              return _buildPermissionRequestUI();
            } else if (_isCameraInitialized) {
              // Check if the camera is initialized
              return CameraPreview(_controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: _buildClickButton(),
    );
  }

  Widget _buildPermissionRequestUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Please allow camera permission to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              var status = await Permission.camera.request();
              _permissionStatus.value = status;
              _initializeCamera();
            },
            child: const Text(
              'Allow camera',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(right: 8, left: 8, bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () async {
          try {
            final XFile file = await _controller.takePicture();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WoundResultScreen(
                  imageFile: File(file.path),
                  patientData: widget.patientData,
                ),
              ),
            );
          } catch (e) {
            kShowSnackBar("Something went wrong. Try again");
          }
        },
        style: TextButton.styleFrom(
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 0, width: 0),
            Text(
              'Click & Next',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
