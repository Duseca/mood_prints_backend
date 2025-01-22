import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._privateConstructor();

  static UserService? _instance;

  static UserService get instance {
    _instance ??= UserService._privateConstructor();
    return _instance!;
  }

  Rx<UserModel> userModel = UserModel().obs;

  Future<void> getUserInformation() async {
    try {
      showLoadingDialog();

      final id = await getStringSharedPrefMethod(key: 'id');

      if (id.isNotEmpty) {
        log('id is Not null -> ${id}');

        final url = getClientByIDUrl + id;
        final response =
            await apiService.get(url, true, showResult: true, successCode: 200);
        hideLoadingDialog();

        if (response != null) {
          final user = response['user'];

          userModel.value = UserModel.fromJson(user);
          log('User Model -> ${userModel.value.toJson()}');

          // Get.to(() => ClientNavBar());
        }
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log("This exception occurred while getting user data: $e");
    }
  }

  Future<String> getStringSharedPrefMethod({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await prefs.getString('$key');

    if (value != null) {
      return value;
    } else {
      return '';
    }
  }
}
