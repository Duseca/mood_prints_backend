import 'dart:developer';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/chat/chat_controller.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/notification/notification_model.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/therapist/therapist_home/therapist_notification.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRequestAccepted = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  // --------------- Get All Notification ---------------

  Future<void> getAllNotification(id) async {
    log("Getting all user notification Called");

    try {
      notificationList.clear();
      isLoading.value = true;
      String getAllNotificationUrl = '$notificationUrl/${id}';

      log("URL: $getAllNotificationUrl");

      final response = await apiService.get(getAllNotificationUrl, false,
          showResult: true, successCode: 200);

      if (response != null) {
        final notifications = response['notifications'];
        if (notifications != null || notifications.isNotEmpty) {
          for (Map<String, dynamic> notification in notifications) {
            if (notification.containsKey('requestId')) {
              notificationList.add(NotificationModel.fromJson(notification));
            }
          }
          log('Notifications is not null: -> ${notificationList.length}');
          isLoading.value = false;
        }
        log('Notifications Response -> ${notificationList.length}');
      }

      isLoading.value = false;
    } catch (e) {
      log("This exception occurred while getting all user notification: $e");
      isLoading.value = false;
    }
  }

  // --------------- Update Notification Status ---------------

  Future<void> updateNotificationStatus({
    required String requestId,
    required String status,
    required String therapistID,
    required String clientID,
  }) async {
    try {
      showLoadingDialog();
      isRequestAccepted.value = true;
      var body = {'requestId': requestId, 'status': status};

      final response = await apiService.putWithBody(
          requestNotificationUrl, body, false,
          showResult: false, successCode: 200);

      if (response != null) {
        final request = response['request'];

        if (request != null && request.isNotEmpty) {
          await buildTherapistClientRelation(
              therapistID: therapistID, clientID: clientID);
          hideLoadingDialog();
          isRequestAccepted.value = false;
          Get.dialog(RequestAcceptedCard());
        } else {
          hideLoadingDialog();
        }
      } else {
        hideLoadingDialog();
      }

      isRequestAccepted.value = false;
    } catch (e) {
      hideLoadingDialog();
      isRequestAccepted.value = false;
      log('Error occurs during Notification Status updating:-> $e');
    }

    update();
  }

  // --------------- Delete Request ---------------

  Future<void> deleteNotificationRequest(
      {required String requestId, String? message, String? title}) async {
    try {
      String url = requestNotificationUrl + '/$requestId';
      log("requestId:--------> $requestId");

      final response = await apiService.delete(url, false,
          showResult: false, successCode: 200);

      if (response != null) {
        Get.dialog(RequestDeclineCard(
          title: title,
          message: message,
        ));
      }
    } catch (e) {
      log('Error occurs during Decline notification request:-> $e');
    }
  }

  // --------------- Delete Notification ---------------

  Future<void> deleteNotification({
    required String notificationID,
  }) async {
    try {
      showLoadingDialog();
      String url = notificationUrl + '/$notificationID';
      log("notification ID:--------> $notificationID");

      final response = await apiService.delete(url, false,
          showResult: true, successCode: 200);

      if (response != null) {
        await getAllNotification(
            UserService.instance.therapistDetailModel.value.id);
        hideLoadingDialog();
      } else {
        hideLoadingDialog();
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error occurs during delete notification:-> $e');
    }
  }

  // --------------- Build therapist & client relation  ---------------

  Future<void> buildTherapistClientRelation({
    required String therapistID,
    required String clientID,
  }) async {
    try {
      log(' Build Relation Called');
      var relationUrl = updateUserUrl + clientID;

      log(' Therapist ID ----------> $therapistID');
      log(' Client ID ----------> $clientID');

      var body = {
        'therapistIds': ['$therapistID'],
      };

      final response = await apiService.putWithBody(relationUrl, body, false,
          showResult: false, successCode: 200);

      if (response != null) {
        final relationships = response['relationships'];

        if (relationships != null && relationships.isNotEmpty) {
          await Get.find<ChatController>()
              .creatingChatThread(participantsID: clientID, myID: therapistID);

          await UserService.instance.getUserInformation();

          log('Chat Thead Called : ---------- ');
        }
      }
    } catch (e) {
      log('Error occurs during building Therapist & Client relation:-> $e');
    }
  }
}
