import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class StageOutlinedButton extends StatelessWidget {
  final void Function() onPressFn;
  final String text;
  final Color borderColor;
  final Color textColor;
  final double height;
  final Color? waitColor;
  final double? borderRadius;
  final double? textHeight;
  final FontWeight? textWeight;
  final String? stage;
  final String? errorMessage;

  const StageOutlinedButton({
    super.key,
    required this.text,
    required this.borderColor,
    required this.textColor,
    required this.onPressFn,
    required this.height,
    this.borderRadius,
    this.waitColor,
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
          borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
          border: Border.all(color: waitColor ?? grey2, width: 2),
        ),
        child: Center(
          child: CircularLoadingIndicator(
            size: height * 0.4,
            color: waitColor ?? grey2,
          ),
        ),
      );
    } else if (stage == 'DONE') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
          border: Border.all(
            color: green,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.done_rounded,
            color: green,
            size: height * 0.66,
          ),
        ),
      );
    } else if (stage == 'ERROR') {
      if (errorMessage != null) {
        return OutlinedButton(
          onPressed: onPressFn,
          style: OutlinedButton.styleFrom(
            backgroundColor: red,
            minimumSize: Size(double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
            ),
          ),
          child: Center(
            child: CustomText(
              text: errorMessage!,
              color: redLight,
              size: height * 0.40,
              weight: FontWeight.w700,
            ),
          ),
        );
      }
      return OutlinedButton(
        onPressed: onPressFn,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: red,
            width: 2.0,
          ),
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.close_rounded,
            color: red,
            size: height * 0.66,
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: onPressFn,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor,
          width: 2.5,
        ),
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontFamily: Fonts().primary,
            fontSize: textHeight ?? 16,
            fontWeight: textWeight,
          ),
        ),
      ),
    );
  }
}
