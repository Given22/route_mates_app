import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get mapboxAccessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static String get sdkRegistryToken => dotenv.env['SDK_REGISTRY_TOKEN'] ?? '';

  // Firebase
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseDatabaseUrl => dotenv.env['FIREBASE_DATABASE_URL'] ?? '';

  // AdMob
  static String get admobAppId => dotenv.env['ADMOB_APP_ID'] ?? '';
  static String get adMapBannerIdAndroid => dotenv.env['AD_MAP_BANNER_ID_ANDROID'] ?? '';
  static String get veryHighAdMapBannerIdAndroid => dotenv.env['VERY_HIGH_AD_MAP_BANNER_ID_ANDROID'] ?? '';
  static String get highAdMapBannerIdAndroid => dotenv.env['HIGH_AD_MAP_BANNER_ID_ANDROID'] ?? '';
  static String get mediumAdMapBannerIdAndroid => dotenv.env['MEDIUM_AD_MAP_BANNER_ID_ANDROID'] ?? '';
  static String get lowAdMapBannerIdAndroid => dotenv.env['LOW_AD_MAP_BANNER_ID_ANDROID'] ?? '';
  static String get rewardAdCreateGroupIdAndroid => dotenv.env['REWARD_AD_CREATE_GROUP_ID_ANDROID'] ?? '';
  static String get offlineFullscreenAdIdAndroid => dotenv.env['OFFLINE_FULLSCREEN_AD_ID_ANDROID'] ?? '';
} 