import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/all_therapist/all_therapist_model.dart';
import 'package:mood_prints/model/user_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';
import 'package:mood_prints/services/image_picker/image_picker.dart';
import 'package:mood_prints/services/user/user_services.dart';

class ProfileController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
        email: emailController.text.trim(),
        phoneNumber: completePhoneNumber,
        dob: DateTimeService.instance.getDateIsoFormat(dob.value!),
        gender: selectedGenderValue.value.toLowerCase(),
        bio: bioController.text,
      );

      final url = updateClientUrl + userId;

      final response = await apiService.putWithBody(url, body.toJson(), false,
          showResult: true, successCode: 200);

      hideLoadingDialog();

      if (response != null) {
        final message = response['message'];
        final user = response['user'];
        log('Message:-> $message');
        if (message != null && message.isNotEmpty) {
          final model = UserModel.fromJson(user);
          UserService.instance.userModel.value = model;
          log("Updated username: ${model.fullName}");
          log("Updated Model: ${model.toJson()}");
          Get.back();
        }
        displayToast(msg: 'User Profile Updated');
        log('User Profile Updated');
      } else {
        log('User Not Updated');
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

      final url = updateClientUrl + UserService.instance.userModel.value.id!;

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
    log("Change Password Called");
    try {
      showLoadingDialog();
      Map<String, dynamic> body = {
        'email': UserService.instance.userModel.value.email,
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
        }
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }
}
