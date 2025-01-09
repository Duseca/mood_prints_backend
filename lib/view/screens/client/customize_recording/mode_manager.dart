import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/view/screens/client/customize_recording/customize_recording.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ModeManager extends StatefulWidget {
  const ModeManager({
    super.key,
  });

  @override
  State<ModeManager> createState() => _ModeManagerState();
}

class _ModeManagerState extends State<ModeManager> {
  // int currentModeIndex = 0;
  int selectedFeeling = 0;
  bool haveEmotionsVisible = false;

  final modeCtrl = Get.find<ModeManagerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: 'Tue, Aug 24', actions: [
        InkWell(
          onTap: () {
            Get.to(() => CustomizeRecording());
          },
          child: Center(
            child: CommonImageView(
              height: 25,
              imagePath: Assets.imagesSettingIcon,
            ),
          ),
        ),
        SizedBox(width: 20),
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.DEFAULT,
              children: [
                // ---------> Color Pallate <---------

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: AppStyling.CUSTOM_CARD,
                  child: Column(
                    children: [
                      MyText(
                        paddingBottom: 16,
                        text: "How is your mood today?*",
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                      CommonImageView(imagePath: Assets.imagesColorPallet),

                      // Mode Selector Tap

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          modeIndicatorItems.length,
                          (index) => Obx(
                            () => Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    modeCtrl.selectedMood.value =
                                        modeIndicatorItems[index];

                                    log('selected Model:=> ${modeCtrl.selectedMood.value.toMap().toString()} ');
                                    // currentModeIndex = index;
                                    // log(currentModeIndex.toString());
                                  },
                                  child: Icon(
                                    ((modeCtrl.selectedMood.value ==
                                            modeIndicatorItems[index]))
                                        ? Icons.radio_button_on_rounded
                                        : Icons.circle,
                                    color: modeIndicatorItems[index].color,
                                  ),
                                ),
                                MyText(
                                  text: '${modeIndicatorItems[index].text}',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: Colors.black54,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Obx(
                        () => Container(
                          margin: EdgeInsets.only(top: 16),
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // color: modeIndicatorItems[currentModeIndex].color,
                            color: modeCtrl.selectedMood.value.color,
                          ),
                          child: Center(
                            child: MyText(
                              text:
                                  // "${modeIndicatorItems[currentModeIndex].mode} Mode",
                                  "${modeCtrl.selectedMood.value.mode} Mode",
                              size: 14,
                              weight: FontWeight.w600,
                              color: kWhiteColor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          feelingItems.length,
                          (index) {
                            return Obx(
                              () => InkWell(
                                onTap: () {
                                  modeCtrl.selectedFeelingModel.value =
                                      feelingItems[index];
                                },
                                child: Image.asset(
                                  (modeCtrl.selectedFeelingModel.value ==
                                          feelingItems[index])
                                      ? feelingItems[index].iconA
                                      : feelingItems[index].iconB,
                                  height: 44,
                                ),
                              ),
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

                // ------- Emotions --------
                // ------- Active Widgets ----------

                (modeCtrl.activeWidgets.isNotEmpty)
                    ? Column(
                        children: List.generate(modeCtrl.activeWidgets.length,
                            (headIndex) {
                          return GetBuilder<ModeManagerController>(
                            init: ModeManagerController(),
                            builder: (ctrl) {
                              bool cardVisiblity =
                                  ctrl.visibilityDisplayCustomCards[
                                          headIndex] ??
                                      false;

                              return _CustomCard(
                                title:
                                    '${ctrl.activeWidgets[headIndex].title}*',
                                visiblity: cardVisiblity,
                                onMore: () {
                                  ctrl.toggleVisibility(headIndex);
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
                                            itemCount: ctrl
                                                .activeWidgets[headIndex]
                                                .data
                                                .length,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                height: Get.height,
                                                // width: 44,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        ctrl.selectedEmojiTextModel
                                                                .value =
                                                            ctrl
                                                                .activeWidgets[
                                                                    headIndex]
                                                                .data[index];

                                                        // ctrl.selectCustomItems(
                                                        //     index);

                                                        log('Selected Emoji Model: ${ctrl.selectedEmojiTextModel.value?.toJson().toString()}');
                                                      },
                                                      child: Obx(
                                                        () => Container(
                                                          height: 44,
                                                          width: 44,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kLightGreyColor,
                                                              border: Border.all(
                                                                  color: (ctrl.selectedEmojiTextModel
                                                                              .value ==
                                                                          ctrl.activeWidgets[headIndex].data[
                                                                              index])
                                                                      ? kSecondaryColor
                                                                      : Colors
                                                                          .transparent,
                                                                  width: 1)),
                                                          child: Center(
                                                            child: MyText(
                                                              text:
                                                                  '${ctrl.activeWidgets[headIndex].data[index].emoji}',
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    MyText(
                                                      text:
                                                          '${ctrl.activeWidgets[headIndex].data[index].text}',
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
                              );
                            },
                          );
                        }),
                      )
                    : SizedBox.shrink(),

                // -------- Static Front-end Widget -------

                // _CustomCard(
                //   title: 'Emotions*',
                //   visiblity: haveEmotionsVisible,
                //   onMore: () {
                //     setState(() {});
                //     if (haveEmotionsVisible == true) {
                //       haveEmotionsVisible = false;
                //     } else {
                //       haveEmotionsVisible = true;
                //     }
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 16),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: SizedBox(
                //             height: 62,
                //             child: ListView.separated(
                //               separatorBuilder: (context, index) {
                //                 return SizedBox(
                //                   width: 16,
                //                 );
                //               },
                //               shrinkWrap: true,
                //               padding: EdgeInsets.zero,
                //               physics: BouncingScrollPhysics(),
                //               scrollDirection: Axis.horizontal,
                //               itemCount: emotionsItems.length + 1,
                //               itemBuilder: (context, index) {
                //                 // ---------- Add more emojis button ------------

                //                 if (index == emotionsItems.length) {
                //                   return AddMoreEmojiButton(
                //                     onTap: () {},
                //                   );
                //                 } else {
                //                   // ---------- Emojis & Text ------------

                //                   return SizedBox(
                //                     height: Get.height,
                //                     // width: 44,
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Container(
                //                           height: 44,
                //                           width: 44,
                //                           decoration: BoxDecoration(
                //                             shape: BoxShape.circle,
                //                             color: kLightGreyColor,
                //                           ),
                //                           child: Center(
                //                             child: MyText(
                //                               text:
                //                                   '${emotionsItems[index]['emoji']}',
                //                               size: 24,
                //                             ),
                //                           ),
                //                         ),
                //                         MyText(
                //                           text:
                //                               '${emotionsItems[index]['text']}',
                //                           size: 12,
                //                         ),
                //                       ],
                //                     ),
                //                   );
                //                 }
                //               },
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 12,
                ),

                // ------- Today Note --------

                _CustomCard(
                  visiblity: true,
                  traillingWidget: SizedBox(),
                  title: 'Today’s note*',
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

                // ------- Today Photo --------

                _CustomCard(
                  title: 'Today’s Photo',
                  visiblity: true,
                  traillingWidget: Image.asset(
                    Assets.imagesAddIcon,
                    height: 25,
                  ),
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

                // ------- Sleep --------

                _CustomCard(
                  title: 'Sleep*',
                  visiblity: true,
                  traillingWidget: SizedBox(),
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
              ],
            ),
          ),

          // ------------ Save Changes Button ----------------

          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save Changes',
              onTap: () {
                // Get.bottomSheet(
                //   EmojiCustomWidget(),
                //   isScrollControlled: true,
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddMoreEmojiButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddMoreEmojiButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: Get.height,
        // width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kSecondaryColor,
                ),
                child: Icon(
                  Icons.add,
                  color: kPrimaryColor,
                )),
            MyText(
              text: 'Add',
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard({
    super.key,
    required this.title,
    required this.onMore,
    required this.child,
    this.visiblity = false,
    this.traillingWidget,
  });
  final String title;
  final Widget child;
  final VoidCallback onMore;
  final bool visiblity;
  final Widget? traillingWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyling.CUSTOM_CARD,
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: title,
                size: 16,
                weight: FontWeight.w600,
                paddingRight: 8,
              ),
              (traillingWidget == null)
                  ? GestureDetector(
                      onTap: onMore,
                      child: Center(
                        child: Image.asset(
                          height: 10,
                          Assets.imagesArrowDownIcon,
                        ),
                      ),
                    )
                  : Container(child: traillingWidget),
            ],
          ),
          Visibility(visible: visiblity, child: child),
        ],
      ),
    );
  }
}
