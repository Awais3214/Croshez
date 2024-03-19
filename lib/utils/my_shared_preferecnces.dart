import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferecne {
  Future saveUserId(String? userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (userId != null) {
      await sharedPreferences.setString("documentId", userId);
    }
  }

  Future saveUserType(String? userType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (userType != null) {
      await sharedPreferences.setString("userType", userType);
    }
  }

  Future saveShopSetupStage(int? shopSetupStage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (shopSetupStage != null) {
      prefs.setInt('shopSetup', shopSetupStage);
    }
  }

  Future clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
