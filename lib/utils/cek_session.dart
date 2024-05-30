import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? idUser, email;

  Future<void> saveSession(
      int val, String id, String email, String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("email", email);
    pref.setString("username", username);
  }

  Future getSession(int val, String id, String email, String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    pref.getString("email");
    pref.getString("username");

    return value;
  }

  //clear session --> logout
  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();
