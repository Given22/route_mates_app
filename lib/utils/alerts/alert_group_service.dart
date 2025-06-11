import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/components/map/alert_panel/alert_panel.dart';

class AlertGroup {
  Future<bool> openDialog(BuildContext context) async {
    String? alertTag = await showDialog<String>(
      context: context,
      builder: (context) => const AlertGroupDialog(),
    );
    if (alertTag == null) {
      return false;
    }
    if (context.mounted) {
      var user = Provider.of<AsyncSnapshot<UserStore?>>(context, listen: false);
      if (user.hasData && user.data!.group.uid.isNotEmpty) {
        _sendAlertToGroup(
          alertTag,
          user.data!.group.uid,
          user.data!.displayName,
        );
        return true;
      }
    }
    return false;
  }

  _sendAlertToGroup(String alertTag, String groupId, String name) async {
    await FBFunctions().alertGroup.call({
      "groupId": groupId,
      "alertTag": alertTag,
      "name": name,
    });
  }
}
