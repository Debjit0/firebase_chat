import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharedpreference/sharedpreference.dart';

class HelperFunctions {
  //keys
  static String UserLoggedInKey = "LOGGEDINKEY";
  static String UserNameKey = "USERNAMEKEY";
  static String UserEmailKey = "USERMAILKEY";

  static Future<bool?> getUserLoggenInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(UserLoggedInKey);
  }
}
