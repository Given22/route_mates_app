import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/slide_page_route.dart';
import 'package:route_mates/src/screens/profile_subpages/garage/new_vehicle_screen.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

import 'package:route_mates/src/widgets/vehicle_box.dart';

class GarageSection extends StatefulWidget {
  const GarageSection({
    super.key,
  });

  @override
  State<GarageSection> createState() => _GarageSectionState();
}

class _GarageSectionState extends State<GarageSection> {
  _showAddVehiclePage() {
    Navigator.push(context, slidePageRouteFromDown(const NewVehicleScreen()));
  }

  _addFirstVehicleBox() {
    return GestureDetector(
      onTap: () {
        _showAddVehiclePage();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(1.0),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: darkGrey,
            // gradient: LinearGradient(
            //   begin: const Alignment(0, -1.5),
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     darkGrey,
            //     darkBg2,
            //   ],
            // ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 5,
              )
            ],
          ),
          height: (MediaQuery.of(context).size.width - 32) * 0.5,
          width: ((MediaQuery.of(context).size.width - 32) * 0.5) * 1.4,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: grey2,
                  size: 28,
                ),
                CustomText(
                  text: "Add first vehicle",
                  color: grey2,
                  fontFamily: Fonts().secondary,
                  letterSpacing: 0.5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var garage = Provider.of<List<Vehicle>>(context);
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    List<Widget> cards = garage.map((member) {
      return VehicleBox(
        uid: member.uid,
        name: member.name,
        description: member.description,
        editable: true,
      );
    }).toList();

    cards = [const SizedBox(), ...cards];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Garage',
                color: grey,
                size: 20,
                weight: FontWeight.w700,
                align: TextAlign.left,
              ),
              if (garage.length < 4)
                TextButton(
                  onPressed: _showAddVehiclePage,
                  child: CustomText(
                    text: 'Add vehicle',
                    color: blueLink,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        if (user.hasData && garage.isNotEmpty)
          CustomHorizontalList(
            customEmptyListText: "",
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            maxWidth: double.infinity,
            maxHeight: (MediaQuery.of(context).size.width) * 0.5,
            gap: 16,
            children: cards,
          ),
        if (user.hasData && garage.isEmpty) _addFirstVehicleBox(),
        if (!user.hasData)
          const Padding(
            padding: EdgeInsets.all(24),
            child: LoadingIndicator(),
          ),
      ],
    );
  }
}
