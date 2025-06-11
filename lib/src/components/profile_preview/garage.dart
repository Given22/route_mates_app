import 'package:flutter/material.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

import 'package:route_mates/src/widgets/vehicle_box.dart';

class GarageSection extends StatefulWidget {
  const GarageSection({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<GarageSection> createState() => _GarageSectionState();
}

class _GarageSectionState extends State<GarageSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Store().userGarageFuture(widget.id),
        builder: (_, future) {
          if (future.connectionState != ConnectionState.done) {
            return SizedBox(
              height: 100,
              child: Center(
                child: LinearProgressIndicator(
                  color: orange,
                  backgroundColor: grey,
                ),
              ),
            );
          }
          if (!future.hasData) {
            return const SizedBox();
          }
          List<Widget> cards = future.data!.map((member) {
            return VehicleBox(
              uid: member.uid,
              name: member.name,
              description: member.description,
              editable: false,
            );
          }).toList();

          if (cards.isEmpty) {
            return const SizedBox();
          }

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
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (future.data!.isNotEmpty)
                CustomHorizontalList(
                  customEmptyListText: "",
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  maxWidth: double.infinity,
                  maxHeight: (MediaQuery.of(context).size.width) * 0.5,
                  gap: 16,
                  children: cards,
                ),
            ],
          );
        });
  }
}
