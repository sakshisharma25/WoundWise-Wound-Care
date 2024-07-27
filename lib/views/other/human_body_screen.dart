import 'package:flutter/material.dart';
import 'package:woundwise/views/components/anatomy_component.dart';

class HumanBodyScreen extends StatelessWidget {
  const HumanBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> selectedPart = ValueNotifier(null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Human Body",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: AnatomyComponent(selectedPart: selectedPart, isEditable: true),
      ),
    );
  }
}
