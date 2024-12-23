import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/screens/client/customize_recording/customize_recording.dart';
import 'package:mood_prints/view/widget/alert_dialogs/delete_dialog.dart';
import 'package:mood_prints/view/widget/custom_card_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class HiddenBlocks extends StatelessWidget {
  const HiddenBlocks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: AppSizes.DEFAULT,
            children: [
              CustomCard(
                title: 'Feeling',
                onEdit: () {},
                onMore: () {
                  Get.dialog(DeleteDialog());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 62,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 16,
                              );
                            },
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: Get.height,
                                width: 44,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kLightGreyColor,
                                      ),
                                      child: Center(
                                        child: MyText(
                                          text: '😁',
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    MyText(
                                      text: 'Proud',
                                      size: 12,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Health',
                onEdit: () {},
                onMore: () {},
                child: SizedBox(),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Self-Care',
                onEdit: () {},
                onMore: () {},
                child: SizedBox(),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Exercise',
                onEdit: () {},
                onMore: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    MyBorderButton(
                      buttonText: '',
                      buttonColor: kBorderColor,
                      bgColor: kOffWhiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesDropIcon,
                            height: 20,
                          ),
                          MyText(
                            paddingLeft: 8,
                            paddingRight: 8,
                            text: 'Record your exercise',
                            size: 14,
                            color: kGreyColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppSizes.DEFAULT,
          child: MyButton(
            buttonText: 'Save Changes',
            onTap: () {
              Get.to(() => CustomizeRecording());
            },
          ),
        ),
      ],
    );
  }
}
