import 'package:get/get.dart';
import 'package:mood_prints/controller/auth/auth_client_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
