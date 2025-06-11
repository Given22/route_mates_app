import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/components/settings/edit_profile_security.dart';
import 'package:route_mates/src/components/menu_screen.dart';
import 'package:route_mates/src/components/settings/link_tile.dart';
import 'package:route_mates/src/components/settings/setting_switcher.dart';
import 'package:route_mates/src/components/settings/setting_tile.dart';
import 'package:route_mates/src/components/settings/tiles_group.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/solid_outlined_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';
import 'package:route_mates/utils/confirm_action_service.dart';
import 'package:route_mates/utils/phone_database.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _do(Function function) async {
    var bgService =
        Provider.of<BackgroundSharingService>(context, listen: false);

    if (await bgService.isServiceAlreadyRunning) {
      if (mounted) {
        await ConfirmAction().certify(
          () async {
            bgService.service.invoke('stopService');
            await function();
          },
          context,
          message: Config().getString("LOGOUT_DIALOG_OFFLINE_TEXT"),
          title: Config().getString("LOGOUT_DIALOG_OFFLINE_HEADER"),
        );
      }
    } else {
      if (mounted) {
        function();
      }
    }
  }

  _logOutButton() {
    Future<void> logOut() async {
      await ConfirmAction().certify(
        () async {
          await PhoneDatabase().deleteFromDisk();
          if (mounted) {
            context.go('/signout');
          }
        },
        context,
        title: Config().getString("LOGOUT_DIALOG_HEADER"),
      );
    }

    return SolidOutlinedButton(
      text: 'Sign out',
      bgColor: redLight,
      color: darkBg,
      borderColor: redLight,
      onPressFn: () => _do(logOut),
      fontWeight: FontWeight.bold,
      height: 40,
    );
  }

  _removeAccountButton() {
    removeAccount() async {
      ConfirmAction().certify(
        () async {
          await Auth().removeAccount(context);
        },
        context,
        message: Config().getString("REMOVE_DIALOG_TEXT"),
        title: Config().getString("REMOVE_DIALOG_HEADER"),
      );
    }

    return SolidOutlinedButton(
      text: 'Remove profile',
      bgColor: darkBg,
      color: redLight,
      borderColor: redLight,
      onPressFn: () => _do(removeAccount),
      height: 40,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Settings',
              color: grey,
              size: 20,
              weight: FontWeight.bold,
            ),
            IconButton(
              onPressed: () {
                context.go('/main', extra: 3);
              },
              iconSize: 30,
              splashRadius: 24,
              icon: Icon(
                Icons.arrow_forward_outlined,
                color: grey,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        const TilesGroup(
          bottomLine: true,
          tiles: [
            SettingTile(
              title: "Notifications",
              children: [
                SettingSwitcher(
                  text: "Alert vibration",
                  valueName: "alert_vibration",
                ),
              ],
            ),
          ],
        ),
        TilesGroup(
          tiles: [
            Config().getString("PRIVACY_POLICY_URL") != ""
                ? LinkTile(
                    title: "Privacy Policy",
                    url: Config().getString("PRIVACY_POLICY_URL"),
                  )
                : const SizedBox(),
          ],
          bottomLine: true,
        ),
        TilesGroup(
          tiles: [
            if (Auth().currentUser != null &&
                Auth().currentUser!.providerData[0].providerId == 'password')
              const SettingTile(
                  title: "Profile security",
                  children: [EditProfileSecutityBox()]),
            SettingTile(title: "Account", children: [
              _logOutButton(),
              const SizedBox(
                height: 16,
              ),
              _removeAccountButton(),
            ]),
          ],
        ),
      ],
    );
  }
}
