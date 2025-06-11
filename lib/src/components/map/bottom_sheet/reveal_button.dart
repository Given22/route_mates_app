import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class RevealButton extends StatelessWidget {
  const RevealButton({
    super.key,
    required this.min,
    required this.max,
    required this.sheetController,
  });

  final DraggableScrollableController sheetController;

  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await sheetController.animateTo(sheetController.size < 0.2 ? max : min,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        height: 24,
        child: Center(
          child: Container(
            height: 6,
            width: 100,
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
