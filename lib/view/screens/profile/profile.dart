import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/model/therapist_model/therapist_detail_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/client/client_profile/client_profile.dart';
import 'package:mood_prints/view/screens/help/help.dart';
import 'package:mood_prints/view/screens/language/language.dart';
import 'package:mood_prints/view/screens/privacy_policy/b_a.dart';
import 'package:mood_prints/view/screens/privacy_policy/hippa_pdf_view.dart';
import 'package:mood_prints/view/screens/privacy_policy/p_s.dart';
import 'package:mood_prints/view/screens/privacy_policy/privacy_policy_page.dart';
import 'package:mood_prints/view/screens/profile/change_pass.dart';
import 'package:mood_prints/view/screens/profile/edit_profile.dart';
import 'package:mood_prints/view/screens/profile/edit_therapist_profile.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  Rx<TherapistDetailModel> model = UserService.instance.therapistDetailModel;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: simpleAppBar(
          title: 'User Profile',
          haveLeading: false,
          centerTitle: false,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                CommonImageView(
                  height: 70,
                  width: 70,
                  radius: 100.0,
                  url: model.value.image,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: '${model.value.fullName}',
                        size: 20,
                        paddingBottom: 4,
                        weight: FontWeight.w700,
                      ),
                      MyText(
                        text: '${model.value.email}',
                        size: 14,
                        color: kQuaternaryColor,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Image.asset(
                  Assets.imagesCrown,
                  height: 38,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: 'Member Since',
                        size: 14,
                        color: kTertiaryColor,
                        weight: FontWeight.w600,
                        paddingLeft: 8,
                        paddingBottom: 4,
                      ),
                      MyText(
                        text: (model.value.createdAt != null)
                            ? '${DateTimeService.instance.getMonthYearFormat(model.value.createdAt!)}'
                            : '',

                        // '${model.value.createdAt}',
                        size: 14,
                        color: kGreyColor,
                        paddingLeft: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36,
            ),
            MyText(
              text: 'SETTINGS',
              size: 12,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 16,
            ),
            _ProfileTile(
              icon: Assets.imagesProfile,
              title: 'Edit Profile',
              onTap: () {
                if (UserTypeService.instance.userType ==
                    UserType.therapist.name) {
                  Get.to(() => EditTherapistProfile());
                } else {
                  Get.to(() => EditProfile());
                }
              },
            ),
            _ProfileTile(
              icon: Assets.imagesPrivacy,
              title: 'Change password',
              onTap: () {
                Get.to(() => ChangePass());
              },
            ),
            _ProfileTile(
              icon: Assets.imagesLanguage,
              title: 'Languages',
              onTap: () {
                Get.to(() => Language());
              },
            ),
            MyText(
              paddingTop: 12,
              text: 'SUPPORT',
              size: 12,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 16,
            ),
            // ------ ------------
            _ProfileTile(
              icon: Assets.imagesPrivacy,
              title: 'Privacy Policy',
              onTap: () {
                Get.to(() => HippaScreen());
              },
            ),
            _ProfileTile(
              icon: Assets.imagesPrivacy,
              title: 'Platform Services Agreement (PSA)',
              onTap: () {
                Get.to(() => HippaScreen());
              },
            ),

            // ------ PSA
            _ProfileTile(
              icon: Assets.imagesPrivacy,
              title: 'Business Associate Agreement (BAA)',
              onTap: () {
                Get.to(() => HippaScreen());
              },
            ),

            _ProfileTile(
              icon: Assets.imagesPrivacy,
              title: 'General Terms of Service',
              onTap: () {
                Get.to(() => HippaScreen());
              },
            ),

            _ProfileTile(
              icon: Assets.imagesHelpCenter,
              title: 'FAQs',
              onTap: () {
                Get.to(() => HelpCenter());
              },
              mBottom: 24,
            ),
            _ProfileTile(
              haveTrailing: true,
              isRed: false,
              icon: Assets.imagesLogout,
              title: 'Delete Account',
              onTap: () {
                Get.dialog(DeleteAccountDialog(
                  onCancelTap: () {
                    Get.back();
                  },
                  onLogoutTap: () async {
                    await Get.find<AuthClientController>().logOutMethod();
                    await Get.find<AuthClientController>().deleteAccountMethod(
                        UserService.instance.therapistDetailModel.value.id
                            .toString());

                    UserService.instance.relationWithClients.clear();
                    UserService.instance.relationWithTherapist.clear();
                  },
                ));
                // Get.dialog(_LogoutDialog(
                //   onCancelTap: () {
                //     Get.back();
                //   },
                //   onLogoutTap: () async {
                //     await Get.find<AuthClientController>().logOutMethod();
                //     UserService.instance.relationWithClients.clear();
                //     UserService.instance.relationWithTherapist.clear();
                //   },
                // ));
              },
              mBottom: 24,
            ),
            _ProfileTile(
              haveTrailing: false,
              isRed: true,
              icon: Assets.imagesLogout,
              title: 'Logout',
              onTap: () {
                Get.dialog(_LogoutDialog(
                  onCancelTap: () {
                    Get.back();
                  },
                  onLogoutTap: () async {
                    await Get.find<AuthClientController>().logOutMethod();
                    Get.find<ClientHomeController>().clearAllData();
                  },
                ));
              },
              mBottom: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.mBottom,
    this.isRed = false,
    this.haveTrailing = true,
  });
  final String icon, title;
  final VoidCallback onTap;
  final double? mBottom;
  final bool? isRed;
  final bool? haveTrailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: mBottom ?? 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 22,
              color: isRed! ? Color(0xffF04438) : kTertiaryColor,
            ),
            Expanded(
              child: MyText(
                text: title,
                size: 14,
                color: isRed! ? Color(0xffF04438) : kTertiaryColor,
                weight: FontWeight.w600,
                paddingLeft: 8,
              ),
            ),
            if (haveTrailing!)
              Image.asset(
                Assets.imagesArrowNext,
                height: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onLogoutTap;
  const _LogoutDialog({
    super.key,
    required this.onCancelTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Logout',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text: 'Are you sure you want to logout?',
                  size: 13,
                  color: kGreyColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                          textColor: kTertiaryColor,
                          bgColor: kWhiteColor,
                          buttonText: 'Cancel',
                          onTap: onCancelTap),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MyButton(
                        bgColor: kRedColor,
                        buttonText: 'Logout',
                        onTap: onLogoutTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
