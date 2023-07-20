import 'package:lagos_events/domain/models/appuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USERKEY = "user";

class LocalDataSource {
  LocalDataSource._internal();
  
  static final LocalDataSource instance = LocalDataSource._internal();
  factory LocalDataSource() {
    return instance;
  }

  localUserLogin(AppUser user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(USERKEY, user.toJson());
  }

  Future<bool> localUserLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(USERKEY);
  }

  Future<AppUser?> getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userJson = sharedPreferences.getString(USERKEY);
    if(userJson != null) {
      return AppUser.fromJson(userJson);
    }
    else {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(USERKEY);
  }




}
