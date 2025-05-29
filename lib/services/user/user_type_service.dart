import 'package:shared_preferences/shared_preferences.dart';

class UserTypeService {
  static final UserTypeService instance = UserTypeService._internal();
  String? userType;

  UserTypeService._internal();

  Future<void> initUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await prefs.getString('userType');
    userType = value;
  }
}
