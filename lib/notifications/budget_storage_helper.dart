import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BudgetStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveBudget(String amount, String mode) async {
    await _storage.write(key: "budget_value", value: amount);
    await _storage.write(key: 'budget_mode', value: mode);
  }

  static Future<String?> getBudget(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeBudget(String key) async {
    return await _storage.delete(key: key);
  }
}
