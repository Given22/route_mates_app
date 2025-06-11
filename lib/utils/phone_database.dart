import 'package:hive_flutter/hive_flutter.dart';

class PhoneDatabase {
  Future<void> init() async {
    await Hive.openBox("Settings");
    await Hive.openBox("main");
    await Hive.openBox("bg_service");
    await save("bg_service", "running", false);
    await save("bg_service", "sharing", false);
  }

  Future save<T>(String boxKey, String key, T value) async {
    final box = Hive.box(boxKey);
    await box.put(key, value);
  }

  Future<int> increaseNumber(
    String boxKey,
    String key, {
    int increment = 1,
  }) async {
    await Hive.initFlutter();
    final box = await Hive.openBox(boxKey);
    int value = 0;
    if (box.containsKey(key)) {
      value = box.get(key);
    }
    value += increment;
    await box.put(key, value);
    return value;
  }

  Future<int> clearNumber(String boxKey, String key) async {
    final box = await Hive.openBox(boxKey);

    await box.put(key, 0);
    return 0;
  }

  T? get<T>(String boxKey, String key) {
    final box = Hive.box(boxKey);

    return box.get(key);
  }

  Stream<BoxEvent> watch(String boxKey, String key) {
    final box = Hive.box(boxKey);

    return box.watch(key: key);
  }

  Future<void> deleteFromDisk() async {
    await Hive.deleteFromDisk();
  }
}
