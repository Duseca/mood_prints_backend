import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/model/notification/notification_model.dart';
import 'package:mood_prints/model/relation_model/relation_client_model.dart';
import 'package:mood_prints/model/relation_model/relation_therapist_model.dart';
import 'package:mood_prints/model/therapist_model/therapist_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._privateConstructor();

  static UserService? _instance;

  static UserService get instance {
    _instance ??= UserService._privateConstructor();
    return _instance!;
  }

  // For Client
  Rx<UserModel> userModel = UserModel().obs;
  RxList<RelationTherapistModel> relationWithTherapist =
      <RelationTherapistModel>[].obs;

  RxList<RequestId> requests = <RequestId>[].obs;
  // For Therapist
  Rx<TherapistDetailModel> therapistDetailModel = TherapistDetailModel().obs;
  RxList<RelationClientModel> relationWithClients = <RelationClientModel>[].obs;

  Future<void> getUserInformation() async {
    try {
      relationWithTherapist.clear();
      relationWithClients.clear();
      requests.clear();
      showLoadingDialog();

      final id = await getStringSharedPrefMethod(key: 'id');

      if (id.isNotEmpty) {
        log('id is Not null -> ${id}');

        final url = getClientByIDUrl + id;
        final response = await apiService.get(url, false,
            showResult: true, successCode: 200);
        hideLoadingDialog();

        if (response != null) {
          final user = response['user'];
          final relationships = response['relationships'];
          final reqs = response['requests'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          final value = await prefs.getString('userType');

          if (value != null && value == 'client') {
            log('Get UserType: ---> $value');
            userModel.value = UserModel.fromJson(user);
            relationships.forEach((relation) {
              relationWithTherapist
                  .add(RelationTherapistModel.fromJson(relation));
            });
            reqs.forEach((relation) {
              requests.add(RequestId.fromJson(relation));
            });
            log('Relation With Therapist List length: ---> ${relationWithTherapist.length}');
          } else if (value != null && value == 'therapist') {
            log('Get UserType: ---> $value');
            therapistDetailModel.value = TherapistDetailModel.fromJson(user);
            relationships.forEach((relation) {
              relationWithClients.add(RelationClientModel.fromJson(relation));
            });
            reqs.forEach((relation) {
              requests.add(RequestId.fromJson(relation));
            });
          }
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

  // -------- User App Use ----------

  // bool isTenDaysCompleted(DateTime updatedDateTime) {
  //   final DateTime now = DateTime.now();
  //   final Duration difference = now.difference(updatedDateTime);
  //   return difference.inDays >= 10;
  // }

  RxBool isAccountAccessBlocked = false.obs;

  void isTenDaysCompleted() {
    bool? appAccess =
        UserService.instance.userModel.value.authorizeMoodPrintsAccess;
    bool? therapistAccess =
        UserService.instance.userModel.value.authorizeTherapistAccess;

    DateTime? updatedDateTime = UserService.instance.userModel.value.updatedAt;

    if (appAccess == false && therapistAccess == false) {
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(
          updatedDateTime != null ? updatedDateTime : DateTime.now());

      isAccountAccessBlocked.value = difference.inDays >= 10;
      log("✅ Updated DateTime: ${updatedDateTime}");
      log("✅ 10 Days completed app access blocked: ${isAccountAccessBlocked.value}");
    }
    log("❌ 10 Days not completed yet you can use app for now.");

    isAccountAccessBlocked.value = false;
  }
}


// bool isTenDaysCompleted(DateTime updatedDateTime) {
 
// }

