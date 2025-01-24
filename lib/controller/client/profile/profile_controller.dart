import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
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

  // Image Picker

  void profileImagePicker() async {
    await ImagePickerService().pickMedia(isImage: true, fromGallery: true);
    String activeImage = ImagePickerService().activeMedia.value;
    if (activeImage.isNotEmpty) {
      selectedProfileImage.value = activeImage;
      log('Selected Profile Image:-> ${selectedProfileImage.value}');
    }
    // log('Active Image Path:-> $activeImage');
  }

  // Update user profile information
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
}
