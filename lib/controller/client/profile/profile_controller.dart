import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/core/enums/notification_type.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/model/client_model/all_therapist/all_therapist_model.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/model/therapist_model/therapist_detail_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';
import 'package:mood_prints/services/image_picker/image_picker.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/client/client_profile/add_new_therapist.dart';

class ProfileController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? completePhoneNumber;
  TextEditingController bioController = TextEditingController();
  RxString selectedGenderValue = 'Male'.obs;
  RxList<String> genderList = <String>['Male', 'Female'].obs;
  var selectedProfileImage = Rxn<String>();
  String? downloadImageUrl;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  // All Therapist
  RxList<AllTherapist> allTherapists = <AllTherapist>[].obs;
  Rxn<AllTherapist> selectedTherapistModel = Rxn<AllTherapist>();
  RxBool isLoading = false.obs;
  // Change Password
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool visiblityOld = false.obs;
  RxBool visiblityNew = false.obs;
  RxBool visiblityConfrim = false.obs;
  RxString countryCode = '1'.obs;
  RxString userPhoneNumber = ''.obs;


  // Image Picker

  void profileImagePicker() async {
    await ImagePickerService().pickMedia(isImage: true, fromGallery: true);
    String activeImage = ImagePickerService().activeMedia.value;
    if (activeImage.isNotEmpty) {
      selectedProfileImage.value = activeImage;
      log('Selected Profile Image:-> ${selectedProfileImage.value}');
    }
  }

  //-------------- Update user profile information --------------

  Future<void> updateUserProfile(
      {required String userId, required String oldProfileImageUrl}) async {
    try {
      showLoadingDialog();

      if (selectedProfileImage.value != null) {
        downloadImageUrl = await FirebaseStorageService.instance.uploadImage(
            imagePath: selectedProfileImage.value!,
            storageFolderPath: 'profile_images');
      }

      UserModel body = UserModel(
        image:
            (downloadImageUrl != null) ? downloadImageUrl : oldProfileImageUrl,
        fullName: fullNameController.text.trim(),
        // email: emailController.text.trim(),
        phoneNumber: completePhoneNumber,
        dob: DateTimeService.instance.getDateIsoFormat(dob.value!),
        gender: selectedGenderValue.value.toLowerCase(),
        bio: bioController.text,
      );

      final url = updateUserUrl + userId;

      final response = await apiService.putWithBody(url, body.toJson(), false,
          showResult: true, successCode: 200);

      hideLoadingDialog();

      if (response != null) {
        final message = response['message'];
        final user = response['user'];

        if (message != null && message.isNotEmpty) {
          if (UserTypeService.instance.userType == UserType.therapist.name) {
            final model = TherapistDetailModel.fromJson(user);
            UserService.instance.therapistDetailModel.value = model;
          } else {
            final model = UserModel.fromJson(user);
            UserService.instance.userModel.value = model;
          }
          Get.back();
        }
        displayToast(msg: 'User Profile Updated');
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error occurs during updating user profile:-> $e');
    }
  }

  // -------- Update Therapist ---------------
  // -------- Get All Therapist ---------------

  Future<void> getAllTherapist() async {
    try {
      allTherapists.clear();
      isLoading.value = true;

      final url = getAllTherapistUrl;

      final response =
          await apiService.get(url, true, showResult: false, successCode: 200);

      isLoading.value = false;

      if (response != null) {
        final List<dynamic> usersJson = response['users'];

        final List<AllTherapist> models =
            usersJson.map((json) => AllTherapist.fromJson(json)).toList();

        allTherapists.addAll(models);

        log("All Therapists Length: ${allTherapists.length}");
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("This exception occurred while getting user data: $e");
    }
  }

  // Save Therapist

  Future<void> changeTherapist() async {
    try {
      showLoadingDialog();

      // UserModel body = UserModel(therapistId: [

      // ]);

      var body = {
        'therapistId': [
          "${selectedTherapistModel.value?.id}",
        ]
      };

      final url = updateUserUrl + UserService.instance.userModel.value.id!;

      final response = await apiService.putWithBody(url, body, false,
          showResult: false, successCode: 200);

      hideLoadingDialog();

      if (response != null) {
        final message = response['message'];
        final user = response['user'];

        log('Message:-> $message');
        if (message != null && message.isNotEmpty) {
          final model = UserModel.fromJson(user);
          UserService.instance.userModel.value = model;
          log("Response : ${response}");
          // log("Updated Model: ${model.toJson()}");
          Get.back();
        }
        // displayToast(msg: 'User Profile Updated');
        log('User Profile Updated');
      } else {
        hideLoadingDialog();
        log('User Not Updated');
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error occurs during updating user profile:-> $e');
    }
  }

  // ---------- Change Password ---------------

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confrimPassword,
  }) async {
    log("Change Password Called ");
    log("User Type: ${UserTypeService.instance.userType}");
    try {
      showLoadingDialog();
      Map<String, dynamic> body = {
        'email': (UserTypeService.instance.userType == UserType.client)
            ? UserService.instance.userModel.value.email
            : UserService.instance.therapistDetailModel.value.email,
        'currentPassword': oldPassword,
        'newPassword': newPassword,
      };
      final response = await apiService.post(getChangePasswordUrl, body, true,
          showResult: false, successCode: 200);
      hideLoadingDialog();

      if (response != null) {
        final message = response['message'];

        if (message == 'Password changed successfully') {
          displayToast(msg: "Password changed successfully");
          Get.close(1);
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          visiblityOld.value = false;
          visiblityNew.value = false;
          visiblityConfrim.value = false;
        }
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  passwordVisibityMethod(RxBool isVisible) {
    isVisible.value == true ? isVisible.value = false : isVisible.value = true;
  }

  // ---------- Request Therapist ---------------
  // ---------- Creating a notification request ---------------

  void requestTherapist({
    String? therapistID,
  }) async {
    if (therapistID != null) {
      log('Request Therapist Called');
      log("Therapist ID: $therapistID");
      log("Client ID: ${UserService.instance.userModel.value.id}");

      showLoadingDialog();

      final body = {
        'therapistId': therapistID,
        'clientId': UserService.instance.userModel.value.id,
        'action': ActionType.create.name,
      };

      final response = await apiService.post(requestNotificationUrl, body, true,
          showResult: true, successCode: 201);

      if (response != null) {
        final message = response['message'];
        final request = response['request'];
        final requestID = request['_id'];

        if (message != null && message.isNotEmpty) {
          await createNotification(
            requestId: requestID,
            therapistId: therapistID,
            title: 'Request from Client',
            fullName: UserService.instance.userModel.value.fullName,
            message: message,
          );

          hideLoadingDialog();

          log('Request Send: $message');
        }
      }

      hideLoadingDialog();
    } else {
      displayToast(msg: "Please select a therapist");
    }
  }

  Future<void> createNotification({
    String? therapistId,
    String? requestId,
    String? title,
    String? fullName,
    String? message,
  }) async {
    log('Create Notification Called');

    final body = {
      'requestId': requestId,
      'userId': UserService.instance.userModel.value.id,
      'therapistId': therapistId,
      'title': title,
      'fullName': fullName,
      'body': '$fullName has requested to select you as their therapist.',
    };

    String createNotificationUrl = notificationUrl;

    final response = await apiService.post(createNotificationUrl, body, true,
        showResult: true, successCode: 201);

    if (response != null) {
      final notification = response['notification'];
      if (notification != null && notification.isNotEmpty) {
        Get.dialog(RequestCard(
          message: '$message',
        ));
        log('Notification Created -------->');
        log('Notification: $notification');
      }
    }
  }


  Future<void> extractCountryCode(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    countryCode.value = number.dialCode ?? '';
    log('Country Code: ${countryCode.value}');
  }




}
