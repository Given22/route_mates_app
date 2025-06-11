import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:route_mates/src/const.dart';

class OutlinedButtonWid extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onPressFn;
  final double borderRadius;
  final double? width;
  final FontWeight? textWeight;
  final double? height;
  final String? preSVG;
  final String? postSVG;

  const OutlinedButtonWid({
    super.key,
    required this.text,
    required this.color,
    required this.borderRadius,
    required this.onPressFn,
    this.width,
    this.textWeight,
    this.height,
    this.preSVG,
    this.postSVG,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressFn,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
        minimumSize: Size(
            width ?? MediaQuery.of(context).size.width * 0.41, height ?? 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          preSVG != null
              ? Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/$preSVG.svg',
                      height: height == null ? 48 : (height! * 0.3),
                    ),
                    const SizedBox(width: 8)
                  ],
                )
              : const SizedBox(),
          Center(
            child: Text(
              text,
              style: TextStyle(
                  color: color,
                  fontFamily: Fonts().primary,
                  fontWeight: textWeight ?? FontWeight.normal,
                  fontSize: height == null ? 48 * 0.4 : (height! * 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}
