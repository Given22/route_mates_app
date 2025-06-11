import 'package:get_time_ago/get_time_ago.dart';

/// this is class to customise outputs of get_time_ago library
class CustomMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => '';

  @override
  String secsAgo(int seconds) => '${seconds}s';

  @override
  String minAgo(int minutes) => '1m';

  @override
  String minsAgo(int minutes) => '${minutes}m';

  @override
  String hourAgo(int minutes) => '1h';

  @override
  String hoursAgo(int hours) => '${hours}h';

  @override
  String dayAgo(int hours) => '1d';

  @override
  String daysAgo(int days) => '${days}d';

  @override
  String wordSeparator() => ' ';
}

/// function to get nice formated string with info how much time ago 'date' was
String howMuchAgo(DateTime date) {
  GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
  final timeAgo = GetTimeAgo.parse(date, locale: 'en');
  return timeAgo;
}
