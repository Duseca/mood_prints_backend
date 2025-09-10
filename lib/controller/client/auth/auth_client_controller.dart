import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/core/enums/user_age_status.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/model/therapist_model/therapist_detail_model.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';
import 'package:mood_prints/services/image_picker/image_picker.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/auth/forgot_pass/forgot_pass_verification.dart';
import 'package:mood_prints/view/screens/auth/sign_up/email_verification.dart';
import 'package:mood_prints/view/screens/bottom_nav_bar/client_nav_bar.dart';
import 'package:mood_prints/view/screens/bottom_nav_bar/therapist_nav_bar.dart';
import 'package:mood_prints/view/screens/launch/get_started.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClientController extends GetxController {
  // FirebaseMessaging fcm = FirebaseMessaging.instance;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController npiNumberController = TextEditingController();
  RxString otpMessage = ''.obs;
  String? otpCode;
  String? newUserTempId;
  String? currentUserType;
  // --- Profile Setup ---
  final TextEditingController phoneNumberController = TextEditingController();
  String? FullPhoneNumber;
  String? gradianFullPhoneNumber;
  String? emergencyFullPhoneNumber;
  RxString selectedGenderValue = 'Male'.obs;
  RxList<String> gender = <String>['Male', 'Female', 'Not Preferred'].obs;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  final TextEditingController BioController = TextEditingController();
  final TextEditingController TherapistAccountNumberController =
      TextEditingController();
  // Rx<String?> selectedProfileImage = Rx<String?>(null);
  var selectedProfileImage = Rxn<String>();
  String? downloadImageUrl;
  RxBool acceptTermsAndCondition = false.obs;
  RxBool ageRestriction = false.obs;
  RxBool usCitizen = false.obs;
  RxBool passwordVisibility = true.obs;
  // ------ User Age Status variable ---------
  Rxn<String> userAgeStatus = Rxn(null);
  // ------ Gardian checks ---------
  RxBool gradian1 = false.obs;
  RxBool gradian2 = false.obs;
  RxBool gradian3 = false.obs;
  RxBool gradian4 = false.obs;
  RxBool gradian5 = false.obs;
  RxBool gradian6 = false.obs;
  RxBool gradian7 = false.obs;
  // ------ 18+ checks ---------
  RxBool adult1 = false.obs;
  RxBool adult2 = false.obs;
  RxBool adult3 = false.obs;
  RxBool adult4 = false.obs;
  RxBool adult5 = false.obs;
  RxBool adult6 = false.obs;
  RxBool adult7 = false.obs;
  RxBool adult8 = false.obs;
  // ------ therapist ---------
  RxBool therapist1 = false.obs;
  RxBool therapist2 = false.obs;
  RxBool therapist3 = false.obs;
  RxBool therapist4 = false.obs;
  RxBool therapist5 = false.obs;
  RxBool therapist6 = false.obs;
  RxBool therapist7 = false.obs;
  // -------- Text Controllers -------

  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianEmailController = TextEditingController();
  final TextEditingController guardianPhoneNumberController =
      TextEditingController();
  Rx<DateTime?> guardianDob = Rx<DateTime?>(null);

  final TextEditingController emergencyNameController = TextEditingController();

  final TextEditingController emergencyEmailController =
      TextEditingController();
  final TextEditingController emergencyPhoneNumberController =
      TextEditingController();
  final TextEditingController signatureController = TextEditingController();

  //  -------------- Google Authentication with Firebase ------------------

  Future<void> googleAuth({String? userType}) async {
    try {
      showLoadingDialog();
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email', 'profile']).signIn();

      if (googleUser == null) {
        hideLoadingDialog();
        log('User canceled the Google sign-in process');
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth?.accessToken == null) {
        // isGoogleAuthLoading.value = false;
        hideLoadingDialog();
        log('Google authentication access token is null');
        return;
      }

      // var auth = googleUser.id;

      final credential = await GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // auth =
      // await FirebaseAuth.instance.signInWithCredential(credential);
      await auth.signInWithCredential(credential);

      log('User signed in: ${auth.currentUser?.displayName}, ${auth.currentUser?.email}');
      log('Google Auth Id: ${auth.currentUser?.uid}');

      //  TODO: IsEmailExist

      bool isEmailExist =
          await isUserExistWithEmail(email: auth.currentUser!.email.toString());

      if (isEmailExist) {
        await socialLoginMethod(email: auth.currentUser!.email.toString());
        hideLoadingDialog();

        log("if: Is email exist: $isEmailExist");
      } else {
        await socialSignUpMethod(
            fullName: '${auth.currentUser?.displayName}',
            email: '${auth.currentUser?.email}',
            userType: userType!,
            authId: auth.currentUser!.uid);

        await UserTypeService.instance.initUserType();
        if (UserTypeService.instance.userType == UserType.client.name) {
          log('Go To Client Nav Bar');
          Get.to(() => ClientNavBar());
        } else {
          log('Go To Therapist Nav Bar');
          Get.to(() => TherapistNavBar());
        }

        hideLoadingDialog();

        log("else: Is email exist: $isEmailExist");
      }

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('An error occurred during Google sign-in: $e');
    }
  }

  //  --- Login Method ---

  Future<void> loginMethod({
    required String email,
    required String password,
  }) async {
    log("Try Called Login");
    log("Email ${email}");
    log("Password ${password}");
    try {
      showLoadingDialog();
      // final fcmToken = await fcm.getToken();
      final fcmToken = await getFcmToken();

      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'deviceToken': fcmToken,
      };

      log("FCM TOKEN LOGIN ------ $fcmToken ");
      final response = await apiService.post(loginUrl, body, true,
          showResult: true, successCode: 200);
      hideLoadingDialog();

      if (response != null) {
        final token = response['token'];
        final user = response['user'];

        if (token != null && token.isNotEmpty) {
          UserModel userModel = UserModel.fromJson(user);
          log('user model -> ${userModel.username}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', userModel.id.toString());
          await prefs.setString('userType', userModel.userType.toString());
          await UserService.instance.getUserInformation();

          if (userModel.userType == 'client') {
            showLoadingDialog();
            await Get.find<ClientHomeController>().getAllBoard();
            hideLoadingDialog();
            Get.to(() => ClientNavBar());
          } else {
            Get.to(() => TherapistNavBar());
          }

          resetValues();
        }
      }

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Social Login Api ---

  Future<void> socialLoginMethod({
    required String email,
  }) async {
    log("Try Called Social signUp method");
    try {
      // final fcmToken = await fcm.getToken();
      final fcmToken = await getFcmToken();

      Map<String, dynamic> body = {
        'email': email,
        'deviceToken': fcmToken,
      };

      final response = await apiService.post(loginUrl, body, true,
          showResult: true, successCode: 200);

      if (response != null) {
        final token = response['token'];
        final user = response['user'];

        if (token != null && token.isNotEmpty) {
          UserModel userModel = UserModel.fromJson(user);
          UserService.instance.userModel.value = userModel;
          log('Social User Model -> ${userModel.username}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', userModel.id.toString());
          await prefs.setString('userType', userModel.userType.toString());
          await UserService.instance.getUserInformation();

          if (userModel.userType == UserType.client.name) {
            Get.to(() => ClientNavBar());
          } else {
            Get.to(() => TherapistNavBar());
          }
        }
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Social SignUp Api ---

  Future<void> socialSignUpMethod({
    required String fullName,
    required String email,
    required String authId,
    required String userType,
    String authProvider = 'google',
  }) async {
    log("Try Called Social signUp method");
    log('User Type ----------- $userType');
    try {
      currentUserType = userType;
      // final fcmToken = await fcm.getToken();
      final fcmToken = await getFcmToken();

      Map<String, dynamic> body = {
        'email': email,
        'googleId': authId,
        'userType': userType,
        'fullName': fullName,
        'authProvider': authProvider,
        'deviceToken': fcmToken,
      };

      final response = await apiService.post(signUpUrl, body, true,
          showResult: false, successCode: 200);

      if (response != null) {
        final token = response['token'];
        final user = response['user'];

        if (token != null && token.isNotEmpty) {
          UserModel userModel = UserModel.fromJson(user);
          UserService.instance.userModel.value = userModel;
          log('Social User Model -> ${userModel.username}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', userModel.id.toString());
          await prefs.setString('userType', userModel.userType.toString());
          await UserService.instance.getUserInformation();
          //
          // if (userModel.userType == UserType.client.name) {
          //   log('Go To Client Nav Bar');
          //   Get.to(() => ClientNavBar());
          // } else {
          //   log('Go To Therapist Nav Bar');
          //   Get.to(() => TherapistNavBar());
          // }
        }
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Checking if a user already exists with the current email using social authentication. ---

  Future<bool> isUserExistWithEmail({
    required String email,
  }) async {
    log("Try Called is-User-Exist-With-Email method");

    try {
      Map<String, dynamic> body = {
        'email': email,
      };

      final response = await apiService.post(checkEmailUrl, body, true,
          showResult: true, successCode: 200);

      if (response != null) {
        final exists = response['exists'];

        if (exists) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      log('This error occured in checking email is exist of not social authentication:-> $e');
      return false;
    }
  }

  //  --- SignUp Method ---

  Future<void> signUpClientMethod({
    required String fullName,
    required String email,
    required String password,
    required String userType,
    required String dob,
    String? npiNumber,
    required String signature,

    // Emergency
    String? emergencyName,
    String? emergencyEmail,
    String? emergencyPhone,

    // Gradian
    String? gradianName,
    String? gradianEmail,
    String? gradianPhone,
    String? gradianDOB,

    // US Citizen
    bool isUsCitizien = true,
    bool guardianInfoComplete = false,
  }) async {
    log("Try Called SignUp");
    log('User Type ----------- $userType');
    try {
      showLoadingDialog();
      currentUserType = userType;
      // final fcmToken = await fcm.getToken();
      final fcmToken = await getFcmToken();

      // Map<String, dynamic> body = {
      //   'email': email,
      //   'password': password,
      //   'userType': userType,
      //   'fullName': fullName,
      //   'authProvider': 'email',
      //   'deviceToken': fcmToken,
      //   'authorizeTherapistAccess': true,
      //   'authorizeMoodPrintsAccess': true,
      // };

      Map<String, dynamic> body;

      if (userType == UserType.therapist.name) {
        body = {
          'email': email,
          'password': password,
          'userType': userType,
          'fullName': fullName,
          'dob': dob,
          'authProvider': 'email',
          'deviceToken': fcmToken,
          'npiNumber': npiNumber,
          'emergencyName': emergencyName ?? '',
          'emergencyEmail': emergencyEmail ?? '',
          'emergencyPhone': emergencyPhone ?? '',
          'confirmUSResidency': isUsCitizien,
          // Signature
          'signatureText': signature,
        };

        log("🔥 signatureText At Therapist Side: ${signature}");
      } else {
        body = {
          'email': email,
          'password': password,
          'userType': userType,
          'fullName': fullName,
          'dob': dob,
          'authProvider': 'email',
          'deviceToken': fcmToken,
          'authorizeTherapistAccess': true,
          'authorizeMoodPrintsAccess': true,
          // Gradian
          'guardianName': gradianName ?? '',
          'guardianEmail': gradianEmail ?? '',
          'guardianPhone': gradianPhone ?? '',
          'guardianDOB': gradianDOB ?? '',
          // Emergency
          'emergencyName': emergencyName ?? '',
          'emergencyEmail': emergencyEmail ?? '',
          'emergencyPhone': emergencyPhone ?? '',

          // US Residency
          'confirmUSResidency': isUsCitizien,
          'guardianInfoComplete': guardianInfoComplete,
          // Signature
          'signatureText': signature,
        };
        log("🔥 signatureText At Client Side: ${signature}");
      }

      final response = await apiService.post(signUpUrl, body, true,
          showResult: true, successCode: 201);
      hideLoadingDialog();

      log("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥");

      if (response != null) {
        final token = response['token'];
        final user = response['user'];
        final id = user['_id'];

        if (token != null && token.isNotEmpty) {
          Get.to(() => EmailVerification(
                email: '$email',
                id: id,
                token: token,
              ));
        }
        log("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥");

        log("🔥🔥🔥🔥 signatureText Submitted: ${signature}");
      }
      log("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥");

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- OTP-Verification ---

  Future<void> otpVerificationMethod({
    required String email,
    required String otp,
    required Widget widget,
    required String token,
    required String id,
  }) async {
    log("Try Called Otp verification");
    log("Email ${email}");
    log("Otp ${otp}");

    try {
      showLoadingDialog();

      Map<String, dynamic> body = {
        'email': email,
        'otp': otp,
      };
      final response = await apiService.post(otpVerificationUrl, body, true,
          showResult: true, successCode: 200);

      hideLoadingDialog();

      if (response != null) {
        otpMessage.value = 'OTP verified successfully.';
        final message = response['message'];
        log('Message:-> $message');
        if (message != null && message.isNotEmpty) {
          newUserTempId = id;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', newUserTempId!);
          await prefs.setString('userType', currentUserType!);

          Get.dialog(widget);
        }
        resetValues();
      } else {
        otpMessage.value = 'Invalid OTP';
        log('Invalid OTP');
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // // ------ Profile Completion ---------

  Future<void> profileImagePicker() async {
    await ImagePickerService().pickMedia(isImage: true, fromGallery: true);
    String activeImage = ImagePickerService().activeMedia.value;

    if (activeImage.isNotEmpty) {
      selectedProfileImage.value = activeImage;
      log('Selected Profile Image:-> ${selectedProfileImage.value}');
    }
  }

  Future<void> profileCompletionMethod() async {
    try {
      if (fullNameController.text.isNotEmpty &&
          FullPhoneNumber != null &&
          // dob.value != null &&
          BioController.text.isNotEmpty) {
        log('Fields Are Not Empty');

        showLoadingDialog();

        if (selectedProfileImage.value != null) {
          downloadImageUrl = await FirebaseStorageService.instance.uploadImage(
              imagePath: selectedProfileImage.value!,
              storageFolderPath: 'profile_images');
        }

        // Update client profile

        if (currentUserType == 'client') {
          log('Current User Type (if)------- $currentUserType ------ Profile Updated');

          UserModel model = UserModel(
            fullName: fullNameController.text.trim(),
            phoneNumber: FullPhoneNumber,
            // dob: DateTimeService.instance.getDateIsoFormat(dob.value!),
            gender: selectedGenderValue.value.toLowerCase(),
            bio: BioController.text,
            image: (downloadImageUrl != null) ? downloadImageUrl : dummyImg,
            authorizeMoodPrintsAccess: true,
            authorizeTherapistAccess: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final url = updateUserUrl + newUserTempId.toString();

          final response = await apiService.putWithBody(
              url, model.toJson(), false,
              showResult: true, successCode: 200);

          hideLoadingDialog();

          if (response != null) {
            final message = response['message'];
            final user = response['user'];
            log('Message:-> $message');
            if (message != null && message.isNotEmpty) {
              final model = UserModel.fromJson(user);
              UserService.instance.userModel.value = model;

              Get.offAll(() => ClientNavBar());
              resetValues();
            }

            log('User Profile Updated');
          } else {
            log('User Not Updated');
          }
        }
        // Update therapist profile

        else {
          log('Current User Type (else)------- $currentUserType ------ Profile Updated');

          TherapistDetailModel model = TherapistDetailModel(
              fullName: fullNameController.text.trim(),
              phoneNumber: FullPhoneNumber,
              // dob: DateTimeService.instance.getDateIsoFormat(dob.value!),
              gender: selectedGenderValue.value.toLowerCase(),
              city: cityController.text.trim(),
              state: stateController.text.trim(),
              country: countryController.text.trim(),
              bio: BioController.text,
              image: (downloadImageUrl != null) ? downloadImageUrl : dummyImg);

          final url = updateUserUrl + newUserTempId.toString();

          final response = await apiService.putWithBody(
              url, model.toJson(), false,
              showResult: true, successCode: 200);

          hideLoadingDialog();

          if (response != null) {
            final message = response['message'];
            final user = response['user'];
            log('Message:-> $message');
            // log('Response:-> $response');
            if (message != null && message.isNotEmpty) {
              final model = TherapistDetailModel.fromJson(user);
              UserService.instance.therapistDetailModel.value = model;

              Get.offAll(() => TherapistNavBar());
              resetValues();
            }

            log('Therapist Profile Updated');
          } else {
            log('User Not Updated');
          }
        }
        resetValues();

        // UserModel model = UserModel(
        //     fullName: fullNameController.text.trim(),
        //     phoneNumber: FullPhoneNumber,
        //     dob: DateTimeService.instance.getDateIsoFormat(dob.value!),
        //     gender: selectedGenderValue.value.toLowerCase(),
        //     bio: BioController.text,
        //     image: (downloadImageUrl != null) ? downloadImageUrl : dummyImg);

        // final updateTherapistURL = updateClientUrl + newUserTempId.toString();

        // final response = await apiService.putWithBody(
        //     updateTherapistURL, model.toJson(), false,
        //     showResult: true, successCode: 200);

        // hideLoadingDialog();

        // if (response != null) {
        //   final message = response['message'];
        //   final user = response['user'];
        //   log('Message:-> $message');
        //   // log('Response:-> $response');
        //   if (message != null && message.isNotEmpty) {
        //     final model = UserModel.fromJson(user);
        //     log("m username: ${model.fullName}");
        //     log("m bio: ${model.bio}");

        //     if (currentUserType == 'client') {
        //       Get.offAll(() => ClientNavBar());
        //     } else {
        //       Get.offAll(() => TherapistNavBar());
        //     }
        //   }

        //   log('User Profile Updated');
        // } else {
        //   log('User Not Updated');
        // }
      } else {
        displayToast(msg: 'Please add all information');
        log('Fields are empty');
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Logout ---
  Future<String> getStringSharedPrefMethod({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await prefs.getString('$key');

    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  // --- getString From Shared Pref ---

  Future<void> logOutMethod() async {
    showLoadingDialog();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('token');
    await prefs.remove('userType');
    Get.offAll(() => GetStarted());
    hideLoadingDialog();
  }

  // --- getString From Shared Pref ---

  Future<void> setStringSharedPrefMethod(
      {required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$key', '$value');
  }

  void checkBoxValue() {
    if (acceptTermsAndCondition == true) {
      acceptTermsAndCondition.value = false;
    } else {
      acceptTermsAndCondition.value = true;
    }
    update();
  }

  void checkBoxToggel(RxBool checkValue) {
    if (checkValue == true) {
      checkValue.value = false;
    } else {
      checkValue.value = true;
    }
    update();
  }

  // void checkBoxValueUSCitizen() {
  //   if (usCitizen == true) {
  //     usCitizen.value = false;
  //   } else {
  //     usCitizen.value = true;
  //   }
  //   update();
  // }

  passwordVisibityMethod() {
    passwordVisibility.value == true
        ? passwordVisibility.value = false
        : passwordVisibility.value = true;
  }

  // --- Reset Controllers values ---

  resetValues() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    stateController.clear();
    countryController.clear();
    cityController.clear();
    BioController.clear();
    npiNumberController.clear();
    acceptTermsAndCondition.value = false;
    selectedProfileImage.value = null;
    dob.value = null;
    phoneNumberController.clear();

    guardianNameController.clear();
    guardianEmailController.clear();
    guardianPhoneNumberController.clear();
    guardianDob.value = null;

    emergencyEmailController.clear();
    emergencyNameController.clear();
    emergencyPhoneNumberController.clear();

    adult1.value = false;
    adult2.value = false;
    adult3.value = false;
    adult4.value = false;
    adult5.value = false;

    gradian1.value = false;
    gradian2.value = false;
    gradian3.value = false;
    gradian4.value = false;
    gradian5.value = false;
    gradian6.value = false;

    therapist1.value = false;
    therapist2.value = false;
    therapist3.value = false;
    therapist4.value = false;
    therapist5.value = false;

    signatureController.clear();

    update();
  }

  // ------ Forget Password ---------

  Future<void> forgetApi({
    String? email,
  }) async {
    try {
      log('Forget Passowrd Api Called');
      showLoadingDialog();
      final body = {'email': email};

      final response = await apiService.post(forgetPasswordUrl, body, true,
          showResult: true, successCode: 200);

      if (response != null) {
        final message = response['message'];
        if (message != null && message.isNotEmpty) {
          // Get.to(() => ForgotPassVerification());

          displayToast(msg: "$message");
          log('Message ---> $message');
          hideLoadingDialog();
          Get.to(() => ForgotPassVerification());
        }
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error Occurs during forget password ---> $e');
    }
  }

  // ------ Reset Password ---------

  Future<void> ResetPasswordApi({
    String? email,
    String? otpCode,
    String? newPassword,
    required Widget widget,
  }) async {
    try {
      log('Reset Passowrd Api Called');
      showLoadingDialog();
      final body = {
        'email': email,
        'otp': otpCode,
        'newPassword': newPassword,
      };

      log("1. Email ${email}");
      log("2. otp ${otpCode}");
      log("3. pass ${newPassword}");

      final response = await apiService.post(resetPasswordUrl, body, true,
          showResult: true, successCode: 200);

      if (response != null) {
        final message = response['message'];
        if (message != null && message.isNotEmpty) {
          // Get.to(() => ForgotPassVerification());

          log("-----------------------------");
          log("33. Email ${email}");
          log("44. otpCode ${otpCode}");
          log("55. password ${newPassword}");

          displayToast(msg: "$message");
          log('Message ---> $message');
          hideLoadingDialog();
          emailController.clear();
          otpCode = null;
          passwordController.clear();
          passwordVisibility.value = true;
          // Get.dialog(widget);
          Get.close(3);
          // Get.offAll(()=>Login());
        }
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error Occurs during forget password ---> $e');
    }
  }

  // ------ Delete Account ---------

  Future<void> deleteAccountMethod(id) async {
    try {
      log('Delete account method Called');
      showLoadingDialog();

      final url = deleteAccountUrl + id;
      final response = await apiService.delete(url, true,
          showResult: true, successCode: 200);

      if (response != null) {
        final message = response['message'];
        if (message != null && message.isNotEmpty) {
          // Get.to(() => ForgotPassVerification());

          displayToast(msg: "$message");
          log('Message ---> $message');
          hideLoadingDialog();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('id');
          await prefs.remove('token');
          await prefs.remove('userType');
          Get.offAll(() => GetStarted());
        }
      }
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error Occurs during delete account ---> $e');
    }
  }

  // Checking User age if the user is between 13 to 17 display toast message make varibale to ture;

  // void checkIfGuardianRequired(DateTime userDob) {
  //   try {
  //     final DateTime now = DateTime.now();
  //     log(" my dob :::: $userDob");
  //     // DateTimeService.instance.getDateIsoFormat(ctrl.dob)

  //     int age = now.year - userDob.year;
  //     if (now.month < userDob.month ||
  //         (now.month == userDob.month && now.day < userDob.day)) {
  //       age--;
  //     }

  //     if (age >= 13 && age <= 17) {
  //       Fluttertoast.showToast(
  //         msg:
  //             "User is between 13-17 years old, you need to add guardian information.",
  //         toastLength: Toast.LENGTH_LONG,
  //       );
  //       isUserAgeBetween13And17.value = true;
  //       log("✅ Age is between 13 - 17 ${isUserAgeBetween13And17.value}");
  //     }

  //     isUserAgeBetween13And17.value = false;
  //   } catch (e) {
  //     isUserAgeBetween13And17.value = false;
  //     log("❌ Error while calculating age");
  //   }
  // }

  void checkIfGuardianRequired(DateTime userDob) {
    try {
      final DateTime now = DateTime.now();
      log("📅 User DOB: $userDob");

      int age = now.year - userDob.year;
      if (now.month < userDob.month ||
          (now.month == userDob.month && now.day < userDob.day)) {
        age--;
      }

      if (age < 13) {
        Fluttertoast.showToast(
          msg: "User under 13, cannot create account.",
          toastLength: Toast.LENGTH_LONG,
        );
        log("🚫 User under 13, cannot create account.");
        userAgeStatus.value = UserAgeStatus.ageLessThan13.name;
      } else if (age >= 13 && age <= 17) {
        Fluttertoast.showToast(
          msg:
              "User is between 13-17 years old, you need to add guardian information.",
          toastLength: Toast.LENGTH_LONG,
        );
        log("✅ User is between 13-17, guardian info required.");
        userAgeStatus.value = UserAgeStatus.age13To17.name;
      } else {
        log("✅ User is 18+, normal flow.");
        userAgeStatus.value = UserAgeStatus.age18Plus.name;
      }
    } catch (e) {
      log("❌ Error while calculating age: $e");
      userAgeStatus.value =
          UserAgeStatus.age18Plus.name; // default safe fallback
    }
  }
}
