import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class SmallSolidButton extends StatelessWidget {
  const SmallSolidButton({
    super.key,
    this.fontWeight,
    this.fontFamily,
    this.size,
    required this.text,
    required this.bgColor,
    required this.color,
    required this.onPressFn,
  });

  final FontWeight? fontWeight;
  final String? fontFamily;
  final String text;
  final double? size;
  final Color bgColor;
  final Color color;
  final void Function() onPressFn;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressFn,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(20, 28),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontFamily: fontFamily ?? Fonts().primary,
            fontWeight: fontWeight ?? FontWeight.w700,
            fontSize: size ?? 14,
          ),
        ),
      ),
    );
  }
}
