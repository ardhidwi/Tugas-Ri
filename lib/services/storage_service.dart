import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyLagu = "pilihan_lagu_user";

  static Future<void> simpanLagu(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLagu, fileName);
  }

  static Future<String> ambilLagu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLagu) ?? "hujan.mp3";
  }
}
