import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:route_mates/utils/env_config.dart';

class Config {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(const {
      "show_alpha_banner": false,
      "alpha_banner_socialmedia_link": "",
      "darkmode_map_url": MapboxStyles.TRAFFIC_NIGHT,
      "lightmode_map_url": MapboxStyles.TRAFFIC_DAY,
      "home_page": true,
      "group_page": true,
      "search_page": true,
      "profile_page": true,
      "map_page": true,
      // =====================
      // Consts
      // ads
      "AD_MAP_BANNER_ID_ANDROID": EnvConfig.adMapBannerIdAndroid,
      // banners
      // android
      "VERY_HIGH_AD_MAP_BANNER_ID_ANDROID": EnvConfig.veryHighAdMapBannerIdAndroid,
      "HIGH_AD_MAP_BANNER_ID_ANDROID": EnvConfig.highAdMapBannerIdAndroid,
      "MEDIUM_AD_MAP_BANNER_ID_ANDROID": EnvConfig.mediumAdMapBannerIdAndroid,
      "LOW_AD_MAP_BANNER_ID_ANDROID": EnvConfig.lowAdMapBannerIdAndroid,
      // ios
      "AD_MAP_BANNER_ID_IOS": "",
      // group rewarded
      // android
      "VERY_HIGH_REWARD_AD_CREATE_GROUP_ID_ANDROID": EnvConfig.rewardAdCreateGroupIdAndroid,
      "HIGH_REWARD_AD_CREATE_GROUP_ID_ANDROID": EnvConfig.rewardAdCreateGroupIdAndroid,
      "MEDIUM_REWARD_AD_CREATE_GROUP_ID_ANDROID": EnvConfig.rewardAdCreateGroupIdAndroid,
      "LOW_REWARD_AD_CREATE_GROUP_ID_ANDROID": EnvConfig.rewardAdCreateGroupIdAndroid,
      // -----
      "REWARD_AD_CREATE_GROUP_ID_ANDROID": EnvConfig.rewardAdCreateGroupIdAndroid,
      
      // offline fullscreen,
      "OFFLINE_FULLSCREEN_AD_ID_ANDROID": EnvConfig.offlineFullscreenAdIdAndroid,
      "OFFLINE_FULLSCREEN_AD_ID_IOS": "",
      // numbers
      "HOW_LONG_ALERT_SHOULD_BE_VISIBLE_IN_SEC": 30,
      "SEND_ALERT_DELAY_IN_SEC": 30,
      "USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES": 20,
      // ======================
      // UI elements
      // Alerts
      "police": "Police!",
      "emergency": "Emergency stop!",
      "gas_station": "I have to refuel",
      "stop": "I need a break",
      "traffic": "I'm stuck at red light",
      "follow_me": "Follow me",
      // Home page
      "HOME_PAGE_HELLO_TEXT": "Hi,",
      "HOME_PAGE_ALPHA_BANNER_TEXT":
          "Drive, connect, and shape the future\nof Route Mates with us!\nYour feedback is key.",
      "HOME_PAGE_ALPHA_BANNER_HEADER": "Welcome to Route Mates Alpha!",
      "HOME_PAGE_GROUP_NOT_A_MEMBER": "You are not a member of any group.",
      "HOME_PAGE_GROUP_NO_ACTIVE_MEMBERS": "No active members available",
      "HOME_PAGE_GROUP_NO_DATA":
          "We cannot find your profile data\nPlease try again later",
      // Notification page
      "NOTIFICATION_PAGE_NO_FILTERS":
          "Your filters are empty, \n you won't see any notifications!",
      "NOTIFICATION_PAGE_EMPTY_BOX": "Your notification box is empty",
      // Without group
      "WITHOUT_GROUP_PIN_BUTTON": "Join via code",
      "WITHOUT_GROUP_BANNER_HEADER": "Want to have own group?",
      "WITHOUT_GROUP_BANNER_FOOTER": "Watch ad to create one",
      "WITHOUT_GROUP_SHOW_MORE":
          "Haven't found the group you are looking for?\nShow more",
      "WITHOUT_GROUP_NO_PUBLIC_GROUPS":
          "We probably don't have any public groups",
      // With group
      "WITH_GROUP_EMPTY_FRIENDS": "You don't have any friends",
      "WITH_GROUP_NOT_MATCH_SEARCH":
          "We can't find any friends matching your search",
      
      "WITH_GROUP_SHOW_MORE":
          "Haven't found the person you are looking for?\nShow more",
      // Members list
      "MEMBERS_PAGE_ERROR": "Something gone wrong",
      "MEMBERS_PAGE_SHOW_MORE":
          "Haven't found the person you are looking for?\nShow more",
      // Search page
      "SEARCH_PAGE_FIND_SOMEONE": "Find your new route mate",
      // Profile page
      "PROFILE_PAGE_NO_FRIENDS": "You don't have any friends yet",
      "FRIENDS_PAGE_NOT_FOUND": "We can't find any user with this name",
      "FRIENDS_PAGE_USER_NOT_HAVE_FRIENDS": "User does't have any friends",
      // Development page
      "DEVELOPMENT_PAGE_MAIN": "This page has been closed until it is repaired",
      "DEVELOPMENT_PAGE_SECOND": "Update app and wait carefully for the fix",
      // Start page
      "START_PAGE_MAIN":
          "Thank you for being here at the start of out journey.",
      "START_PAGE_SECOND":
          "Let's hit the road together and make Route Mates fantastic!",
      "START_PAGE_HEADER": "Welcome in the alpha version of",
      // map page
      "MAP_PAGE_SHEET_NOT_A_MEMBER":
          "You are not a member of any group\nJoin to group to see live members.",
      "MAP_PAGE_SHEET_EMPTY_ACTIVE_MEMBERS": "No active members available",

      "LOGOUT_DIALOG_OFFLINE_HEADER": "Stop sharing location?",
      "LOGOUT_DIALOG_OFFLINE_TEXT": "To log out, you must first be offline.",
      "LOGOUT_DIALOG_HEADER": "Log out?",
      "REMOVE_DIALOG_HEADER": "Remove account?",
      "REMOVE_DIALOG_TEXT": "Your account will be removed permanently.",

      // links
      "PRIVACY_POLICY_URL": "https://route-mates.com",
    });

    await remoteConfig.fetchAndActivate();
  }

  String getString(String key) {
    return remoteConfig.getString(key).replaceAll('\\n', '\n');
  }

  bool getBool(String key) {
    return remoteConfig.getBool(key);
  }

  double getDouble(String key) {
    return remoteConfig.getDouble(key);
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }
}
