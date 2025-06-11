import 'package:flutter/material.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.alpha,
  });

  final bool alpha;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (alpha)
          Column(
            children: [
              CustomText(
                text: Config().getString('START_PAGE_HEADER'),
                color: grey,
                weight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        const SizedBox(
          height: 52,
          child: Align(
            alignment: Alignment.center,
            child: LongLogo(
              size: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}
