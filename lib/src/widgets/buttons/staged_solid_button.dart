import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class StageSolidButton extends StatelessWidget {
  final void Function() onPressFn;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double? borderRadius;
  final double height;
  final double? textHeight;
  final FontWeight? textWeight;
  final String? stage;
  final String? errorMessage;

  const StageSolidButton({
    super.key,
    required this.borderRadius,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.onPressFn,
    required this.height,
    this.stage,
    this.textWeight,
    this.textHeight,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (stage == 'WAITING') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 1.5),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: grey2,
        ),
        child: Center(
          child: CircularLoadingIndicator(
            size: height * 0.4,
            color: darkBg,
          ),
        ),
      );
    } else if (stage == 'DONE') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            color: green),
        child: Center(
          child: Icon(
            Icons.done_rounded,
            color: grey,
            size: height * 0.66,
          ),
        ),
      );
    } else if (stage == 'ERROR') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: redLight,
        ),
        child: Center(
          child: errorMessage != null
              ? CustomText(
                  text: errorMessage!,
                  color: darkBg,
                  size: textHeight ?? 16,
                  weight: FontWeight.bold,
                )
              : Icon(
                  Icons.close_rounded,
                  color: grey,
                  size: height * 0.66,
                ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressFn,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(double.infinity, height),
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
              fontSize: textHeight ?? 16,
              fontWeight: textWeight),
        ),
      ),
    );
  }
}
