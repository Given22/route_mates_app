import 'package:flutter/material.dart';
import 'package:route_mates/src/components/groups/without/create_group_banner.dart';
import 'package:route_mates/src/components/groups/without/pin_section.dart';
import 'package:route_mates/src/components/groups/without/public_groups.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class WithoutGroupPage extends StatefulWidget {
  const WithoutGroupPage({super.key});

  @override
  State<WithoutGroupPage> createState() => _WithoutGroupPageState();
}

class _WithoutGroupPageState extends State<WithoutGroupPage> {
  _header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'Groups',
            color: grey,
            size: 20,
            weight: FontWeight.w700,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBg2,
            darkBg,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _header(),
                const PinInputSection(),
                const CreateGroupBanner(),
                const SizedBox(
                  height: 32,
                ),
                const PublicGroups(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
