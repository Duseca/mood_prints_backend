import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
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

  // For Therapist
  Rx<TherapistDetailModel> therapistDetailModel = TherapistDetailModel().obs;
  RxList<RelationClientModel> relationWithClients = <RelationClientModel>[].obs;

  Future<void> getUserInformation() async {
    try {
      relationWithTherapist.clear();
      relationWithClients.clear();
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
          final relationships = response['relationships'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          final value = await prefs.getString('userType');

          if (value != null && value == 'client') {
            log('Get UserType: ---> $value');
            userModel.value = UserModel.fromJson(user);
            relationships.forEach((relation) {
              relationWithTherapist
                  .add(RelationTherapistModel.fromJson(relation));
            });
            log('Relation With Therapist List length: ---> ${relationWithTherapist.length}');
          } else if (value != null && value == 'therapist') {
            log('Get UserType: ---> $value');
            therapistDetailModel.value = TherapistDetailModel.fromJson(user);
            relationships.forEach((relation) {
              relationWithClients.add(RelationClientModel.fromJson(relation));
            });
            // log('User Model -> ${therapistDetailModel.value.toJson()}');
            // log('Relation with Clients Length:   -> ${relationWithClients.length}');
          }

          // userModel.value = UserModel.fromJson(user);
          // log('User Model -> ${userModel.value.toJson()}');
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
