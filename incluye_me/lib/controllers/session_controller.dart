import 'package:shared_preferences/shared_preferences.dart';

class SessionController {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
