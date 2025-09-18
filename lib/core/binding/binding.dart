import 'package:get/get.dart';
import 'package:mood_prints/controller/chat/chat_controller.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/controller/faqs_controller.dart';
import 'package:mood_prints/controller/notification/notification_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthClientController>(AuthClientController());
  }
}

class FAQsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FaqsController>(FaqsController());
  }
}

class BottomBarBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ClientHomeController>(ClientHomeController());
    Get.put<ModeManagerController>(ModeManagerController());
    Get.put<ProfileController>(ProfileController());
    Get.put<ChatController>(ChatController());
    Get.put<NotificationController>(NotificationController());
  }
}
