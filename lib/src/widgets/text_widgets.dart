import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontFamily,
    this.color,
    this.size,
    this.height,
    this.weight,
    this.align,
    this.maxTextLength,
    this.screenPartMaxWidth,
    this.letterSpacing,
  });

  final String text;
  final String? fontFamily;
  final Color? color;
  final double? size;
  final double? height;
  final FontWeight? weight;
  final TextAlign? align;
  final double? screenPartMaxWidth;
  final int? maxTextLength;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    String displayedText = text;
    if (maxTextLength != null && maxTextLength! > 0) {
      if (text.length > maxTextLength!) {
        displayedText = '${text.substring(0, maxTextLength!)}..';
      }
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenPartMaxWidth != null
            ? MediaQuery.of(context).size.width * screenPartMaxWidth!
            : double.infinity,
      ),
      child: Text(
        displayedText,
        textAlign: align,
        style: TextStyle(
          letterSpacing: letterSpacing,
          height: height,
          fontSize: size ?? 16,
          color: color ?? Colors.black,
          fontFamily: fontFamily ?? Fonts().primary,
          fontWeight: weight ?? FontWeight.normal,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}

Widget textSeparator(String text) {
  line() {
    return Flexible(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        ),
      ),
    );
  }

  return Row(
    children: [
      line(),
      const SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(
          fontFamily: Fonts().primary,
        ),
      ),
      const SizedBox(width: 10),
      line(),
    ],
  );
}
