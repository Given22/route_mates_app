import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/small_solid_button.dart';

import 'package:route_mates/src/widgets/loading_widgets.dart';

class ButtonsSection extends StatefulWidget {
  const ButtonsSection({
    super.key,
    required this.onAccept,
    required this.onDeclined,
  });

  final Future<void> Function() onAccept;
  final Future<void> Function() onDeclined;

  @override
  State<ButtonsSection> createState() => _ButtonsSectionState();
}

class _ButtonsSectionState extends State<ButtonsSection> {
  bool loading = false;

  _accept() async {
    setState(() {
      loading = true;
    });
    await widget.onAccept();
  }

  _decline() async {
    setState(() {
      loading = true;
    });
    await widget.onDeclined();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      FlutterView view = PlatformDispatcher.instance.views.first;
      double physicalWidth = view.physicalSize.width;
      double devicePixelRatio = view.devicePixelRatio;
      double screenWidth = physicalWidth / devicePixelRatio;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 45,
            width: screenWidth * 0.4,
            child: const LoadingIndicator(),
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SmallSolidButton(
          text: 'Accept',
          bgColor: Colors.green,
          color: darkGrey,
          onPressFn: _accept,
        ),
        const SizedBox(
          width: 8,
        ),
        IconButton(
          onPressed: _decline,
          iconSize: 32,
          splashRadius: 24,
          icon: Icon(
            Icons.highlight_off,
            color: grey,
          ),
        ),
      ],
    );
  }
}
