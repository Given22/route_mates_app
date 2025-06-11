import 'package:flutter/material.dart';
import 'package:route_mates/src/components/garage/new_vehicle_box.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class NewVehicleScreen extends StatefulWidget {
  const NewVehicleScreen({super.key});

  @override
  State<NewVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'New vehicle',
              color: grey,
              size: 20,
              weight: FontWeight.w600,
            ),
            CustomText(
              text: 'Show off your vehicle to others.',
              color: grey2,
              size: 18,
              fontFamily: Fonts().secondary,
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
          splashRadius: 24,
          icon: Icon(
            Icons.arrow_downward_outlined,
            color: grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkBg,
      body: SafeArea(
        child: GestureDetector(
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
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  NewVehicleBox(
                    afterFunction: () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
