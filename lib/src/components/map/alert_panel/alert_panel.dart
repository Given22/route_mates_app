import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/view.dart';

class AlertGroupDialog extends StatefulWidget {
  const AlertGroupDialog({super.key});

  @override
  State<AlertGroupDialog> createState() => _AlertGroupDialogState();
}

class _AlertGroupDialogState extends State<AlertGroupDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      elevation: 3,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 10),
                blurRadius: 10,
              )
            ],
            color: darkBg2,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ViewOrientation().isPortrait(context) ? 2 : 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio:
                    ViewOrientation().isPortrait(context) ? 4 / 5 : 5 / 3,
              ),
              itemBuilder: (context, index) {
                String alertTag = Alerts().icons.keys.toList()[index];
                return GestureDetector(
                  onTap: () {
                    context.pop(alertTag);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: darkGrey,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 5),
                            blurRadius: 5,
                          )
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Alerts().icons[alertTag],
                            color: grey2,
                            size: 48,
                          ),
                          CustomText(
                            text: Config().getString(alertTag),
                            color: grey2,
                            size: 16,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
