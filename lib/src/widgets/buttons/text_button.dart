import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class TextButtonWid extends StatelessWidget {
  final void Function() onPressFn;
  final String text;
  final Color textColor;
  final FontWeight? textWeight;
  final double? textSize;

  const TextButtonWid({
    super.key,
    required this.onPressFn,
    required this.text,
    required this.textColor,
    this.textWeight,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(textColor),
        textStyle: MaterialStateProperty.all(
          TextStyle(
              fontWeight: textWeight ?? FontWeight.normal, fontSize: textSize),
        ),
      ),
      onPressed: onPressFn,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: Fonts().primary,
        ),
      ),
    );
  }
}
