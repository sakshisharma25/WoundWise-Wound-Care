import 'package:flutter/material.dart';

class BodyPart {
  final String name;
  final Offset position;
  final Size size;
  final bool isLeftSide;

  BodyPart(
      {required this.name,
      required this.position,
      required this.size,
      this.isLeftSide = false});
}
