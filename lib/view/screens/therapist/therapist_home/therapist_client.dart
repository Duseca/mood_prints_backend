import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/therapist/report/report.dart';
import 'package:mood_prints/view/screens/therapist/therapist_home/therapist_notification.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class TherapistClient extends StatelessWidget {
  const TherapistClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: simpleAppBar(
          title: 'Client',
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => TherapistNotificationPage());
              },
              child: SizedBox(
                height: 22,
                width: 22,
                child: Center(
                  child: CommonImageView(
                    imagePath: Assets.imagesBellIcon,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
          centerTitle: false,
          haveLeading: false,
        ),
        body: Obx(() => (UserService.instance.relationWithClients.isNotEmpty)
            ? Column(
                children: [
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () {
                      return UserService.instance.getUserInformation();
                    },
                    child: ListView.builder(
                      itemCount:
                          UserService.instance.relationWithClients.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: AppSizes.DEFAULT,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CommonImageView(
                                      height: 44,
                                      width: 44,
                                      radius: 100,
                                      url: UserService
                                          .instance
                                          .relationWithClients[index]
                                          .clientId
                                          ?.image,
                                      // Assets.imagesProfileImageUser,
                                    ),
                                    MyText(
                                      paddingLeft: 12,
                                      text:
                                          '${UserService.instance.relationWithClients[index].clientId?.fullName}',
                                      size: 16,
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 36,
                                  width: 111,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border:
                                          Border.all(color: kSecondaryColor),
                                      color: kSecondaryColor.withOpacity(0.2)),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => Report(
                                            clientID: UserService
                                                .instance
                                                .relationWithClients[index]
                                                .clientId
                                                ?.id
                                                .toString(),
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CommonImageView(
                                          height: 16,
                                          width: 16,
                                          imagePath: Assets.imagesStatsIcon,
                                        ),
                                        MyText(
                                          paddingLeft: 4,
                                          text: 'View Stats',
                                          size: 12,
                                          weight: FontWeight.w600,
                                          color: kSecondaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ))
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_accounts_outlined,
                      color: kGreyColor.withOpacity(0.5),
                      size: 50,
                    ),
                    MyText(
                      paddingTop: 10,
                      text: 'No Clients Found',
                      size: 16,
                      weight: FontWeight.w300,
                      color: kGreyColor.withOpacity(0.7),
                    )
                  ],
                ),
              )));
  }
}
