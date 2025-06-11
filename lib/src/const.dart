// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:route_mates/fire/config.dart';

// Light
Color white = const Color(0xFFFFFFFF);
Color grey = const Color(0xFFF5F5F5);
Color grey2 = const Color(0xFFE0E0E0);

// Colors
Color green = const Color(0xFF199C46);
Color red = const Color(0xFFA61818);
Color redLight = const Color(0xFFFF2020);
Color orange = const Color(0xFFE29414);

// Dark
Color darkBg = const Color(0xFF131316);
Color darkBg2 = const Color(0xFF17181D);
Color darkGrey = const Color(0xFF1F2229);
Color darkGrey5 = const Color(0xFF1A1D23);
Color darkGrey2 = const Color.fromARGB(255, 46, 46, 57);
Color darkGrey3 = const Color(0xFF26262C);

// Blue
Color darkBlue = const Color(0xFF39556F);
Color blueLink = const Color(0xFF6A8298);
Color blueLight2 = const Color(0xFF0085E5);
Color blueDark = const Color(0xFF14213D);

class Fonts {
  String get quattrocento => 'Satoshi';
  String get poppins => 'Nunito';
  String get satoshi => 'Satoshi';
  String get roboto => 'Roboto';
  String get primary => 'Nunito';
  String get secondary => 'Rubik';
}

class Alerts {
  Map<String, IconData> icons = {
    "police": Icons.local_police_rounded,
    "emergency": Icons.emergency_rounded,
    "gas_station": Icons.local_gas_station_rounded,
    "stop": Icons.local_parking_rounded,
    "traffic": Icons.traffic_rounded,
    "follow_me": Icons.navigation_rounded,
  };
}

// TODO: ogarnąć reklamy gdy będzie ios
class AdsIDs {
  List<String> map_banner_android = <String>[
    Config().getString("VERY_HIGH_AD_MAP_BANNER_ID_ANDROID"),
    Config().getString("HIGH_AD_MAP_BANNER_ID_ANDROID"),
    Config().getString("MEDIUM_AD_MAP_BANNER_ID_ANDROID"),
    Config().getString("LOW_AD_MAP_BANNER_ID_ANDROID"),
  ];
  List<String> map_banner_ios = <String>[
    Config().getString("AD_MAP_BANNER_ID_IOS"),
    Config().getString("AD_MAP_BANNER_ID_IOS"),
    Config().getString("AD_MAP_BANNER_ID_IOS"),
    Config().getString("AD_MAP_BANNER_ID_IOS"),
  ];

  List group_rewarded_android = <String>[
    Config().getString("VERY_HIGH_REWARD_AD_CREATE_GROUP_ID_ANDROID"),
    Config().getString("HIGH_REWARD_AD_CREATE_GROUP_ID_ANDROID"),
    Config().getString("MEDIUM_REWARD_AD_CREATE_GROUP_ID_ANDROID"),
    Config().getString("LOW_REWARD_AD_CREATE_GROUP_ID_ANDROID"),
  ];
  List group_rewarded_ios = <String>[
    Config().getString("REWARD_AD_CREATE_GROUP_ID_IOS"),
    Config().getString("REWARD_AD_CREATE_GROUP_ID_IOS"),
    Config().getString("REWARD_AD_CREATE_GROUP_ID_IOS"),
    Config().getString("REWARD_AD_CREATE_GROUP_ID_IOS"),
  ];

  String offline_fullscreen_android =
      Config().getString("OFFLINE_FULLSCREEN_AD_ID_ANDROID");
  String offline_fullscreen_ios =
      Config().getString("OFFLINE_FULLSCREEN_AD_ID_IOS");
}

final int HOW_LONG_ALERT_SHOULD_BE_VISIBLE_IN_SEC =
    Config().getInt("HOW_LONG_ALERT_SHOULD_BE_VISIBLE_IN_SEC");
final int SEND_ALERT_DELAY_IN_SEC = Config().getInt("SEND_ALERT_DELAY_IN_SEC");
final int USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES =
    Config().getInt("USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES");

final String AD_MAP_BANNER_ID_ANDROID =
    Config().getString("AD_MAP_BANNER_ID_ANDROID");
final String AD_MAP_BANNER_ID_IOS = Config().getString("AD_MAP_BANNER_ID_IOS");

final String REWARD_AD_CREATE_GROUP_ID_ANDROID =
    Config().getString("REWARD_AD_CREATE_GROUP_ID_ANDROID");
final String REWARD_AD_CREATE_GROUP_ID_IOS =
    Config().getString("REWARD_AD_CREATE_GROUP_ID_IOS");

const String PUBLIC_GROUP_TOOLTIP_MESSAGE =
    "When you make a group public, it will appear in the list of public groups. Everyone will be allowed to participate.";
