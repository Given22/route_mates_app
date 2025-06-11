import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class BigSolidButton extends StatelessWidget {
  final void Function() onPressFn;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double? borderRadius;
  final double? height;
  final FontWeight? textWeight;

  const BigSolidButton({
    super.key,
    required this.borderRadius,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.onPressFn,
    required this.height,
    this.textWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressFn,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(double.infinity, height ?? 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontFamily: Fonts().primary,
            fontSize: height != null
                ? height! < 40
                    ? (height! * 0.45)
                    : (height! * 0.4)
                : 16,
            fontWeight: textWeight,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
