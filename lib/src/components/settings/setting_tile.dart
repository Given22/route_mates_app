import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({super.key, required this.children, required this.title});

  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: CustomText(
        text: title,
        size: 16,
        color: grey,
        weight: FontWeight.bold,
      ),
      iconColor: orange,
      textColor: grey,
      collapsedIconColor: grey,
      shape: const Border(),
      childrenPadding: const EdgeInsets.all(8),
      children: children,
    );
  }
}
