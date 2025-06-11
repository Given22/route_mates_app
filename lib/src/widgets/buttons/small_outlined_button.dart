import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class SmallOulinedButtonWid extends StatelessWidget {
  const SmallOulinedButtonWid({
    super.key,
    required this.text,
    required this.color,
    required this.borderRadius,
    required this.onPressFn,
    this.textWeight,
  });

  final String text;
  final Color color;
  final void Function() onPressFn;
  final double borderRadius;
  final FontWeight? textWeight;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressFn,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
        minimumSize: const Size(20, 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            color: color,
            fontFamily: Fonts().primary,
            fontWeight: textWeight ?? FontWeight.normal),
      )),
    );
  }
}
