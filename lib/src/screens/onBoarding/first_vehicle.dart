import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/src/components/garage/new_vehicle_box.dart';
import 'package:route_mates/src/components/menu_screen.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class FirstVehicle extends StatelessWidget {
  const FirstVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Add your first vehicle',
              color: grey,
              size: 18,
              weight: FontWeight.bold,
            ),
            TextButtonWid(
              onPressFn: () {
                if (context.mounted) {
                  context.go('/first_friends');
                }
              },
              text: "Skip",
              textColor: grey,
              textSize: 18,
            ),
          ],
        ),
        NewVehicleBox(
          afterFunction: () {
            if (context.mounted) {
              context.go('/first_friends');
            }
          },
        ),
      ],
    );
  }
}
