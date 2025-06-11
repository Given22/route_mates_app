import 'package:flutter/material.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/src/components/log_in_dialog.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/view.dart';

class ConfirmAction {
  Future<void> certify(
    Function functionToConfirm,
    BuildContext context, {
    String message = "",
    String title = "Are you sure?",
  }) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black,
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0, -1.5),
              end: Alignment.bottomCenter,
              colors: [
                darkGrey3,
                darkGrey,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: BoxConstraints(
              maxWidth: ViewOrientation().isPortrait(context)
                  ? double.infinity
                  : MediaQuery.of(context).size.width * 0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomText(
                    text: title,
                    color: grey,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (message.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomText(
                      text: message,
                      color: grey2,
                      align: TextAlign.center,
                      size: 16,
                      fontFamily: Fonts().secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
                BigSolidButton(
                  borderRadius: 12,
                  text: "Yes",
                  buttonColor: orange,
                  textWeight: FontWeight.w900,
                  textColor: darkBg,
                  onPressFn: () {
                    Navigator.pop(context, true);
                  },
                  height: 40,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CustomText(
                    text: "No",
                    color: grey,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirm == null || !confirm) {
      return;
    }
    functionToConfirm();
  }

  Future<UserSecurity> reloginWithPassword(BuildContext context) async {
    UserSecurity? userSecurity = await showDialog<UserSecurity>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 2,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return const LogInDialogContent();
        }),
      ),
    );
    if (userSecurity == null) {
      return UserSecurity(
        email: "",
        password: "",
      );
    }
    return userSecurity;
  }
}
