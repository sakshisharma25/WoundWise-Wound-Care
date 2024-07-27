import 'package:flutter/material.dart';
import 'package:woundwise/models/body_part_model.dart';

class AnatomyComponent extends StatefulWidget {
  const AnatomyComponent({
    super.key,
    required this.selectedPart,
    required this.isEditable,
  });

  final ValueNotifier<String?> selectedPart;
  final bool isEditable;

  @override
  State<AnatomyComponent> createState() => _AnatomyComponentState();
}

class _AnatomyComponentState extends State<AnatomyComponent> {
  final TextEditingController controller = TextEditingController();
  bool isFontPartVisiable = true;

  @override
  void initState() {
    super.initState();
    if (widget.selectedPart.value != null) {
      controller.text = widget.selectedPart.value!;
    }
  }

  final List<BodyPart> fontBodyParts = [
    // Forehead
    BodyPart(
      name: "Forehead",
      position: const Offset(157, 17),
      size: const Size(40, 22),
    ),
    // Eyes
    BodyPart(
      name: "Right Eye",
      position: const Offset(157, 40),
      size: const Size(20, 8),
    ),
    BodyPart(
      name: "Left Eye",
      position: const Offset(180, 40),
      size: const Size(20, 8),
    ),
    // Nose
    BodyPart(
      name: "Nose",
      position: const Offset(173, 49),
      size: const Size(9, 9),
    ),
    // Ears
    BodyPart(
      name: "Right Ear",
      position: const Offset(150, 48),
      size: const Size(9, 12),
    ),

    BodyPart(
      name: "Left Ear",
      position: const Offset(195, 48),
      size: const Size(9, 12),
    ),
    // Cheeks
    BodyPart(
      name: "Right Cheek",
      position: const Offset(159, 48),
      size: const Size(14, 22),
    ),
    BodyPart(
      name: "Left Cheek",
      position: const Offset(183, 48),
      size: const Size(14, 22),
    ),
    // Mouth
    BodyPart(
      name: "Mouth",
      position: const Offset(171, 56),
      size: const Size(16, 10),
    ),
    // Neck
    BodyPart(
      name: "Neck",
      position: const Offset(160, 78),
      size: const Size(35, 20),
    ),
    // Shoulders
    BodyPart(
      name: "Right Shoulder",
      position: const Offset(110, 90),
      size: const Size(55, 20),
    ),
    BodyPart(
      name: "Left Shoulder",
      position: const Offset(195, 90),
      size: const Size(55, 20),
    ),
    // Thorex
    BodyPart(
      name: "Thorex",
      position: const Offset(165, 110),
      size: const Size(20, 40),
    ),
    // Chest
    BodyPart(
      name: "Right Chest",
      position: const Offset(130, 110),
      size: const Size(35, 40),
    ),
    BodyPart(
      name: "Left Chest",
      position: const Offset(185, 110),
      size: const Size(35, 40),
    ),
    // Right Arms
    BodyPart(
      name: "Right Arm",
      position: const Offset(75, 110),
      size: const Size(55, 60),
    ),
    BodyPart(
      name: "Right Forearm",
      position: const Offset(40, 170),
      size: const Size(55, 45),
    ),
    // Left Arm
    BodyPart(
      name: "Left Arm",
      position: const Offset(220, 110),
      size: const Size(55, 60),
    ),
    BodyPart(
      name: "Left Forearm",
      position: const Offset(250, 170),
      size: const Size(60, 45),
    ),
    // Hands
    BodyPart(
      name: "Left Hand",
      position: const Offset(302, 215),
      size: const Size(24, 25),
    ),
    BodyPart(
      name: "Right Hand",
      position: const Offset(20, 214),
      size: const Size(24, 25),
    ),
    // Thumbs
    BodyPart(
      name: "Right Hand Thumb",
      position: const Offset(2, 214),
      size: const Size(20, 10),
    ),
    BodyPart(
      name: "Left Hand Thumb",
      position: const Offset(322, 218),
      size: const Size(20, 10),
    ),
    // Fingers
    BodyPart(
      name: "Right Hand Fingers",
      position: const Offset(2, 235),
      size: const Size(40, 28),
    ),
    BodyPart(
      name: "Left Hand Fingers",
      position: const Offset(310, 238),
      size: const Size(32, 28),
    ),
    // Thighs
    BodyPart(
      name: "Right Thigh",
      position: const Offset(100, 250),
      size: const Size(62, 90),
    ),
    BodyPart(
      name: "Left Thigh",
      position: const Offset(182, 250),
      size: const Size(62, 80),
    ),
    // Knees
    BodyPart(
      name: "Left Knee",
      position: const Offset(210, 330),
      size: const Size(30, 30),
    ),
    BodyPart(
      name: "Right Knee",
      position: const Offset(100, 340),
      size: const Size(30, 30),
    ),
    // Legs
    BodyPart(
      name: "Right Leg",
      position: const Offset(80, 370),
      size: const Size(45, 80),
    ),
    BodyPart(
      name: "Left Leg",
      position: const Offset(222, 360),
      size: const Size(45, 90),
    ),
    // Feet
    BodyPart(
      name: "Right Feet",
      position: const Offset(65, 450),
      size: const Size(35, 40),
    ),
    BodyPart(
      name: "Left Feet",
      position: const Offset(250, 450),
      size: const Size(35, 40),
    ),
    // Umbilicus
    BodyPart(
      name: "Umbilicus",
      position: const Offset(150, 150),
      size: const Size(50, 70),
    ),
    // Abdomen
    BodyPart(
      name: "Abdomen",
      position: const Offset(130, 220),
      size: const Size(90, 20),
    ),
  ];

  final List<BodyPart> backBodyParts = [
    // Head
    BodyPart(
      name: "Head (Back Side)",
      position: const Offset(138, 30),
      size: const Size(35, 48),
    ),
    // Eyes
    BodyPart(
      name: "Left Ear (Back Side)",
      position: const Offset(130, 56),
      size: const Size(8, 18),
    ),
    BodyPart(
      name: "Right Ear (Back Side)",
      position: const Offset(173, 56),
      size: const Size(8, 18),
    ),
    // Neck
    BodyPart(
      name: "Neck (Back Side)",
      position: const Offset(138, 78),
      size: const Size(35, 30),
    ),
    // Shoulders
    BodyPart(
      name: "Left Shoulder (Back Side)",
      position: const Offset(88, 93),
      size: const Size(48, 20),
    ),
    BodyPart(
      name: "Right Shoulder (Back Side)",
      position: const Offset(174, 93),
      size: const Size(50, 20),
    ),
    // Arms
    BodyPart(
      name: "Left Arm (Back Side)",
      position: const Offset(75, 110),
      size: const Size(35, 50),
    ),
    BodyPart(
      name: "Right Arm (Back Side)",
      position: const Offset(205, 110),
      size: const Size(35, 50),
    ),
    // Albows
    BodyPart(
      name: "Left Albows (Back Side)",
      position: const Offset(60, 160),
      size: const Size(35, 20),
    ),
    BodyPart(
      name: "Right Albows (Back Side)",
      position: const Offset(225, 160),
      size: const Size(35, 20),
    ),
    // Forearms
    BodyPart(
      name: "Left Forearm (Back Side)",
      position: const Offset(25, 180),
      size: const Size(45, 35),
    ),
    BodyPart(
      name: "Right Forearm (Back Side)",
      position: const Offset(240, 180),
      size: const Size(48, 32),
    ),
    // Hands
    BodyPart(
      name: "Left Hand (Back Side)",
      position: const Offset(15, 214),
      size: const Size(24, 25),
    ),
    BodyPart(
      name: "Right Hand (Back Side)",
      position: const Offset(278, 215),
      size: const Size(24, 25),
    ),
    // Thumbs
    BodyPart(
      name: "Left Hand Thumb (Back Side)",
      position: const Offset(2, 220),
      size: const Size(16, 8),
    ),
    BodyPart(
      name: "Right Hand Thumb (Back Side)",
      position: const Offset(300, 218),
      size: const Size(16, 8),
    ),
    // Fingers
    BodyPart(
      name: "Left Hand Fingers (Back Side)",
      position: const Offset(2, 237),
      size: const Size(32, 24),
    ),
    BodyPart(
      name: "Right Hand Fingers (Back Side)",
      position: const Offset(282, 238),
      size: const Size(32, 24),
    ),
    // Thighs
    BodyPart(
      name: "Left Thigh (Back Side)",
      position: const Offset(90, 270),
      size: const Size(62, 60),
    ),
    BodyPart(
      name: "Right Thigh (Back Side)",
      position: const Offset(172, 270),
      size: const Size(52, 60),
    ),
    // Knees
    BodyPart(
      name: "Left Knee (Back Side)",
      position: const Offset(85, 340),
      size: const Size(30, 30),
    ),
    BodyPart(
      name: "Right Knee (Back Side)",
      position: const Offset(200, 330),
      size: const Size(30, 30),
    ),

    // Legs
    BodyPart(
      name: "Left Leg (Back Side)",
      position: const Offset(60, 370),
      size: const Size(45, 80),
    ),

    BodyPart(
      name: "Right Leg (Back Side)",
      position: const Offset(210, 360),
      size: const Size(45, 90),
    ),

    // Feet
    BodyPart(
      name: "Left Feet (Back Side)",
      position: const Offset(50, 450),
      size: const Size(35, 30),
    ),
    BodyPart(
      name: "Right Feet (Back Side)",
      position: const Offset(230, 450),
      size: const Size(35, 30),
    ),
    // Umbilicus
    BodyPart(
      name: "Back",
      position: const Offset(110, 110),
      size: const Size(90, 100),
    ),
    // Abdomen
    BodyPart(
      name: "Lumber Region",
      position: const Offset(115, 210),
      size: const Size(80, 20),
    ),
    BodyPart(
      name: "Left Hip",
      position: const Offset(115, 230),
      size: const Size(40, 40),
    ),
    BodyPart(
      name: "Right Hip",
      position: const Offset(160, 230),
      size: const Size(40, 40),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("<< Swipe to see the ${isFontPartVisiable ? 'back' : 'front'} side >>"),
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                // swipe left
                setState(() {
                  isFontPartVisiable = !isFontPartVisiable;
                });
              } else if (details.primaryVelocity! < 0) {
                // swipe right
                setState(() {
                  isFontPartVisiable = !isFontPartVisiable;
                });
              }
            },
            child: Container(
              height: 500,
              alignment: Alignment.center,
              child: Stack(
                children: (isFontPartVisiable)
                    ? [
                        Image.asset('assets/font-body.png', fit: BoxFit.cover),
                        ...fontBodyParts.map(
                          (part) => Positioned(
                            left: part.position.dx,
                            top: part.position.dy,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.isEditable) {
                                  widget.selectedPart.value = part.name;
                                  controller.text = part.name;
                                }
                              },
                              child: Container(
                                width: part.size.width,
                                height: part.size.height,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        Image.asset('assets/back-body.png', fit: BoxFit.cover),
                        ...backBodyParts.map(
                          (part) => Positioned(
                            left: part.position.dx,
                            top: part.position.dy,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.isEditable) {
                                  widget.selectedPart.value = part.name;
                                  controller.text = part.name;
                                }
                              },
                              child: Container(
                                width: part.size.width,
                                height: part.size.height,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (isFontPartVisiable)
                  ? [
                      const Text("Right"),
                      const Text("Left"),
                    ]
                  : [
                      const Text("Left"),
                      const Text("Right"),
                    ]),
          TextButton.icon(
            icon: Icon(
              isFontPartVisiable ? Icons.rotate_left_rounded : Icons.rotate_right_rounded,
              color: Colors.black,
            ),
            label: Text(
              isFontPartVisiable ? 'Show Back' : 'Show Front',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              setState(() {
                isFontPartVisiable = !isFontPartVisiable;
              });
            },
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Point a Location:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    enabled: widget.isEditable,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Select or write a body part',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      widget.selectedPart.value = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
