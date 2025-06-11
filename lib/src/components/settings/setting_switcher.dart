import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/phone_database.dart';

class SettingSwitcher extends StatefulWidget {
  const SettingSwitcher(
      {super.key, required this.text, required this.valueName});

  final String text;
  final String valueName;

  @override
  State<SettingSwitcher> createState() => _SettingSwitcherState();
}

class _SettingSwitcherState extends State<SettingSwitcher> {
  bool _value = false;

  @override
  void initState() {
    bool? data = PhoneDatabase().get<bool>("Settings", widget.valueName);
    _value = data ?? true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        widget.text,
        style: TextStyle(color: grey, fontFamily: Fonts().secondary),
      ),
      inactiveTrackColor: darkGrey2,
      inactiveThumbColor: grey,
      activeColor: orange,
      activeTrackColor: orange.withAlpha(100),
      value: _value,
      contentPadding: const EdgeInsets.only(left: 24),
      onChanged: (bool value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}
