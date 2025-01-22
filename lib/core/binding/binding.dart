import 'package:get/get.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ModeManagerController>(ModeManagerController());
    Get.put<ClientHomeController>(ClientHomeController());
    Get.put<ProfileController>(ProfileController());
  }
}
