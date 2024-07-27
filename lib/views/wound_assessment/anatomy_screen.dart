import 'package:flutter/material.dart';
import 'package:woundwise/views/components/anatomy_component.dart';

class AnatomyScreen extends StatelessWidget {
  AnatomyScreen({super.key, required this.selectedPart});
  final ValueNotifier<String?> selectedPart;
  final ValueNotifier<String> tempSelectedPart = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    tempSelectedPart.value = selectedPart.value ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: const Text(
            'Wound Location',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(26, 35, 126, 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: TextButton(
              onPressed: () {
                // Save the selected part
                if (tempSelectedPart.value.isNotEmpty) {
                  selectedPart.value = tempSelectedPart.value;
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              ),
              child: const Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnatomyComponent(selectedPart: tempSelectedPart, isEditable: true),
    );
  }
}
