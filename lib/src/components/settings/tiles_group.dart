import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class TilesGroup extends StatelessWidget {
  const TilesGroup(
      {super.key,
      this.tiles = const [],
      this.topLine = false,
      this.bottomLine = false});

  final bool topLine;
  final bool bottomLine;
  final List<Widget> tiles;

  Widget line() {
    return Container(
      decoration:
          BoxDecoration(color: grey2, borderRadius: BorderRadius.circular(1)),
      height: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topLine) line(),
        ...tiles.nonNulls,
        if (bottomLine) line(),
      ],
    );
  }
}
