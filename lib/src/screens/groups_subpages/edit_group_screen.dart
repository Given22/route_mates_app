import 'package:flutter/material.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/src/components/groups/settings/group_data.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class EditGroupPage extends StatelessWidget {
  const EditGroupPage({super.key, required this.group});

  final AsyncSnapshot<Group?> group;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBg,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Group',
                          color: grey,
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          iconSize: 30,
                          splashRadius: 24,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: grey,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GroupData(
                        group: group,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
