import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woundwise/models/patients_model.dart';

class PatientTile extends StatelessWidget {
  final PatientModel patientData;
  final bool showViewButton;
  final bool showSelectButton;

  const PatientTile(
      {super.key, required this.patientData, required this.showViewButton, required this.showSelectButton});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: (patientData.profileImageUrl != null)
                    ? CachedNetworkImage(
                        imageUrl: patientData.profileImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildDemoPicture(),
                        errorWidget: (context, url, error) => _buildDemoPicture(),
                      )
                    : (patientData.profileImagePath != null)
                        ? Image.file(
                            File(patientData.profileImagePath!),
                            fit: BoxFit.cover,
                          )
                        : _buildDemoPicture(),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patientData.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          "${patientData.id}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7.0),
                  Row(
                    children: [
                      Text(
                        'Gender: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        patientData.gender.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Age: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        patientData.age.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      // const Text(
                      //   '50% Pending',
                      //   style: TextStyle(
                      //     color: Colors.orange,
                      //     fontWeight: FontWeight.w500,
                      //
                      //   ),
                      // ),
                      const Spacer(),
                      if (showViewButton || showSelectButton)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              showViewButton
                                  ? 'View '
                                  : showSelectButton
                                      ? "Select"
                                      : "",
                              style: const TextStyle(
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Color(0xFF1A237E),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
