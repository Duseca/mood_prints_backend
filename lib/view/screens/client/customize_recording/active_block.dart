import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/view/screens/client/customize_recording/customize_recording.dart';
import 'package:mood_prints/view/widget/alert_dialogs/delete_dialog.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_card_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ActiveBlock extends StatelessWidget {
  const ActiveBlock({
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
              MyButton(
                buttonText: '',
                bgColor: kLightGreenColor,
                textColor: kQuaternaryColor,
                customChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.imagesAddIcon,
                      height: 20,
                      color: kSecondaryColor,
                    ),
                    MyText(
                      paddingLeft: 8,
                      paddingRight: 8,
                      text: 'Create new block',
                      size: 16,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                onTap: () {
                  Get.bottomSheet(
                    _CreateNewBlockBottomSheet(),
                    isScrollControlled: true,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: AppStyling.CUSTOM_CARD,
                child: Column(
                  children: [
                    MyText(
                      text: 'How stressed are you feeling?*',
                      size: 16,
                      paddingBottom: 20,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        9,
                        (index) {
                          final List<String> _items = [
                            Assets.imagesExtremeCrying,
                            Assets.imagesLittleCrying,
                            Assets.imagesSad,
                            Assets.imagesSad1,
                            Assets.imagesLittleSad,
                            Assets.imagesHappy,
                            Assets.imagesSmile,
                            Assets.imagesLittleSmiling,
                            Assets.imagesLaughing,
                          ];
                          return Image.asset(
                            _items[index],
                            height: 44,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomCard(
                title: 'Emotions*',
                onEdit: () {
                  Get.bottomSheet(
                    _EditBottomSheet(),
                    isScrollControlled: true,
                  );
                },
                onMore: () {},
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
                title: 'Today’s note*',
                onEdit: () {},
                onMore: () {},
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: MyTextField2(
                    hintText: 'Write here...',
                    marginBottom: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Today’s Photo',
                onEdit: () {},
                onMore: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesImagePlaceHolder2,
                      height: 300,
                      radius: 12,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Sleep',
                onEdit: () {},
                onMore: () {},
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: MyButton(
                    customChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesMoon,
                          height: 20,
                        ),
                        MyText(
                          paddingLeft: 8,
                          paddingRight: 8,
                          text: 'Record your sleep',
                          size: 14,
                          color: kWhiteColor,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    buttonText: '',
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'New',
                onEdit: () {},
                onMore: () {},
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
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              if (index == 1) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      _IconNameBottomSheet(),
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Image.asset(
                                    Assets.imagesAddIconRounded,
                                    height: 62,
                                  ),
                                );
                              }
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
                                          text: '🍇',
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    MyText(
                                      text: 'Grape',
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

class _IconNameBottomSheet extends StatelessWidget {
  const _IconNameBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesArrowBackSimple,
                  width: 20,
                  height: 20,
                ),
              ),
              MyText(
                text: 'Create new block',
                weight: FontWeight.w600,
                size: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesCross,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
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
                            text: '🍇',
                            size: 24,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Image.asset(
                          Assets.imagesEditRounded,
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                MyTextField2(
                  hintText: '14 characters max.',
                  marginBottom: 6,
                ),
                MyText(
                  textAlign: TextAlign.end,
                  text: '0/14',
                  color: kGreyColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MyButton(
            buttonText: 'Done',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CreateNewBlockBottomSheet extends StatelessWidget {
  const _CreateNewBlockBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                height: 20,
              ),
              MyText(
                text: 'Create new block',
                weight: FontWeight.w600,
                size: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesCross,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 20,
                ),
                MyTextField2(
                  hintText: '14 characters max.',
                  marginBottom: 6,
                ),
                MyText(
                  textAlign: TextAlign.end,
                  text: '0/14',
                  color: kGreyColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MyButton(
            buttonText: 'Done',
            onTap: () {
              // Get.to(() => NewBlockAdded());
            },
          ),
        ],
      ),
    );
  }
}

class _EditBottomSheet extends StatelessWidget {
  const _EditBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                height: 20,
              ),
              MyText(
                text: 'Edit',
                weight: FontWeight.w600,
                size: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesCross,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 20,
                ),
                MyText(
                  onTap: () {
                    Get.back();
                    Get.bottomSheet(
                      _EditBlockNameBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                  text: 'Edit block name',
                  paddingBottom: 20,
                ),
                MyText(
                  text: 'Unhide',
                  paddingBottom: 20,
                ),
                MyText(
                  onTap: () {
                    Get.dialog(DeleteDialog());
                  },
                  text: 'Delete',
                  paddingBottom: 20,
                  color: kRedColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MyButton(
            buttonText: 'Done',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _EditBlockNameBottomSheet extends StatelessWidget {
  const _EditBlockNameBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                height: 20,
              ),
              MyText(
                text: 'Edit block name',
                weight: FontWeight.w600,
                size: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesCross,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 20,
                ),
                MyTextField2(
                  hintText: '14 characters max.',
                  marginBottom: 6,
                ),
                MyText(
                  textAlign: TextAlign.end,
                  text: '0/14',
                  color: kGreyColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MyButton(
            buttonText: 'Done',
            onTap: () {
              // Get.to(() => NewBlockAdded());
            },
          ),
        ],
      ),
    );
  }
}
