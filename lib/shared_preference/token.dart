import 'package:shared_preferences/shared_preferences.dart';

class TokenUtil {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getTokenExpiryTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenExpiryTime');
  }

  static Future<String?> getDeviceID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceID');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('appVersion');
  }

  static Future<String?> getDomainName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('domainName');
  }

  static Future<String?> getSavedIsPickedDetails(String SKUId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SKUId);
  }
}
