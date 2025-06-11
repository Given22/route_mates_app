import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class SolidOutlinedButton extends StatelessWidget {
  const SolidOutlinedButton({
    super.key,
    required this.text,
    this.bgColor,
    required this.color,
    required this.borderColor,
    required this.onPressFn,
    this.fontWeight,
    this.height,
    this.textHeight,
    this.borderRadius,
  });

  final String text;
  final Color? bgColor;
  final Color color;
  final Color borderColor;
  final FontWeight? fontWeight;
  final void Function() onPressFn;
  final double? height;
  final double? textHeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressFn,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? Colors.transparent,
        minimumSize: Size(double.infinity, height ?? 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          side: BorderSide(color: borderColor, width: 2, strokeAlign: 1),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontFamily: Fonts().primary,
            fontSize: height != null
                ? height! < 40
                    ? (height! * 0.45)
                    : (height! * 0.4)
                : 16,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
