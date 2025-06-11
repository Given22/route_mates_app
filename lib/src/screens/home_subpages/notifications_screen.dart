import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/functions/date.dart';
import 'package:route_mates/src/widgets/buttons/small_solid_button.dart';
import 'package:route_mates/src/widgets/listItems/notifications/friend_listitem.dart';
import 'package:route_mates/src/widgets/listItems/notifications/group_listitem.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/utils/phone_database.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var _groups = true;
  var _friends = true;

  @override
  void initState() {
    PhoneDatabase().clearNumber("main", "notifications_amount");
    super.initState();
  }

  Widget _toggleButtons() {
    return Row(
      children: [
        SmallSolidButton(
          size: 14,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts().secondary,
          text: 'Friends',
          bgColor: _friends ? orange : darkGrey2,
          color: _friends ? darkBg : grey,
          onPressFn: () {
            setState(() {
              _friends = !_friends;
            });
          },
        ),
        const SizedBox(
          width: 8,
        ),
        SmallSolidButton(
          size: 14,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts().secondary,
          text: 'Groups',
          bgColor: _groups ? orange : darkGrey2,
          color: _groups ? darkBg : grey,
          onPressFn: () {
            setState(() {
              _groups = !_groups;
            });
          },
        )
      ],
    );
  }

  _allNotifications() {
    List<GotRequest> gotRequest = Provider.of<List<GotRequest>>(context);

    List<GotRequest> notifications = [];

    for (var element in gotRequest) {
      notifications.add(element);
    }

    if (!_friends && !_groups) {
      return Center(
        child: CustomText(
          text: Config().getString("NOTIFICATION_PAGE_NO_FILTERS"),
          color: grey2,
          align: TextAlign.center,
          fontFamily: Fonts().secondary,
        ),
      );
    }

    notifications.sort((a, b) => a.date.seconds.compareTo(b.date.seconds));

    notifications = notifications.where((element) {
      if (_friends && element.type == 'friend') {
        return true;
      }
      if (_groups && element.type == 'group') {
        return true;
      }
      return false;
    }).toList();

    if (notifications.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/empty_box.svg',
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: Config().getString("NOTIFICATION_PAGE_EMPTY_BOX"),
            size: 16,
            color: grey2,
            fontFamily: Fonts().secondary,
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      );
    }

    List<Widget?> notificationsWidgets = notifications.map((element) {
      final userUid = element.userUid;
      final userName = element.userName;

      final time = element.date;
      final type = element.type;

      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);

      final ago = howMuchAgo(dateTime);
      final timeText = ago.length > 3 ? '+7d' : ago;

      if (element.type == 'friend') {
        return FriendshipNotificationListItem(
          time: timeText,
          name: userName,
          uid: userUid,
          type: type,
        );
      }

      if (element.type == 'group') {
        final groupUid = element.groupUid;
        final groupName = element.groupName;

        return GroupNotificationListItem(
          type: type,
          time: timeText,
          userName: userName,
          userUid: userUid,
          groupName: groupName!,
          groupUid: groupUid!,
        );
      }
      return null;
    }).toList();

    notificationsWidgets.removeWhere((element) => element == null);

    const double gap = 16;
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Container(
        height: (notifications.length * 56 * 2) +
            ((notifications.length - 1) * gap) +
            (notifications.length * 8),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.7),
        child: ListView.separated(
          itemCount: notifications.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return notificationsWidgets[index];
          },
          separatorBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(
                  height: 7,
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                      color: darkGrey,
                      borderRadius: const BorderRadius.all(Radius.circular(2))),
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Notifications',
                  color: grey,
                  size: 20,
                  weight: FontWeight.w700,
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
              height: 8,
            ),
            SizedBox(
              height: 28,
              child: _toggleButtons(),
            ),
            Expanded(
              child: _allNotifications(),
            )
          ]),
        ),
      ),
    );
  }
}
