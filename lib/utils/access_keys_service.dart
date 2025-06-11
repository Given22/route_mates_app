import 'package:hive_flutter/hive_flutter.dart';
import 'package:route_mates/fire/functions.dart';

class AccessKeysService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<bool> checkKey(String key) async {
    bool result = false;
    await FBFunctions().checkKey.call({"key": key}).then((value) {
      if (value.data.toString() == 'true') {
        result = true;
      }
    });
    return result;
  }

  Future<bool> saveKeyOnPhone(String key) async {
    final box = Hive.box('keys');
    await box.put('key', key);
    return await box.get('key') == key;
  }

  Future<bool> keyOnPhone() async {
    final box = await Hive.openBox('keys');
    String? data = box.get('key');

    return (data != null && data.isNotEmpty);
  }
}
