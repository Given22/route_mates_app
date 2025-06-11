import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/custom_icon.dart';

class Navbar extends StatelessWidget {
  const Navbar(
      {super.key, required this.setActiveIndex, required this.activeIndex});
  final Function(int) setActiveIndex;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconList = [
      CustomIcons.convoy,
      Icons.map_rounded,
      Icons.search_rounded,
      Icons.person_rounded,
    ];

    List<Widget> navbarItems = iconList.asMap().entries.map(
      (entry) {
        int index = entry.key;
        IconData icon = entry.value;

        return GestureDetector(
          onTap: () {
            setActiveIndex(index);
          },
          child: Container(
            height: 50,
            width: 60,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: grey,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: activeIndex == index ? 4 : 0,
                  margin: EdgeInsets.only(top: (activeIndex == index ? 4 : 0)),
                  width: activeIndex == index ? 32 : 0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    color: activeIndex == index ? orange : null,
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 56,
      decoration: BoxDecoration(
        color: darkGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -0.5),
            blurRadius: 7,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [...navbarItems],
      ),
    );
  }
}
