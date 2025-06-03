import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/screens/client/customize_recording/customize_recording.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
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
  final modeCtrl = Get.find<ModeManagerController>();

  @override
  void dispose() {
    super.dispose();
    modeCtrl.clearBoardEntries();
  }

  void showDatePickerOnTitleTap() {
    log('work');

    Get.bottomSheet(
      isScrollControlled: true,
      CustomBottomSheet(
        height: Get.height * 0.45,
        // height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Column(
                children: [
                  DobPicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: modeCtrl.datePicker.value,
                    onDateTimeChanged: (dateTime) {
                      modeCtrl.dateTime = dateTime;
                    },
                    onTap: () {
                      if (modeCtrl.dateTime != null) {
                        modeCtrl.datePicker.value = modeCtrl.dateTime!;
                      }

                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: simpleAppBar(
            title:
                '${DateTimeService.instance.getSimpleUSDateFormat(modeCtrl.datePicker.value)}',
            // onTitleTap: showDatePickerOnTitleTap,
            actions: [
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
                          text: "How are you feeling right now?",
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: modeCtrl.selectedMood.value.color,
                            ),
                            child: Center(
                              child: MyText(
                                text: "${modeCtrl.selectedMood.value.mode}",
                                size: 14,
                                weight: FontWeight.w600,
                                color:
                                    (modeCtrl.selectedMood.value.stressLevel >=
                                                0 &&
                                            modeCtrl.selectedMood.value
                                                    .stressLevel <=
                                                3)
                                        ? kTertiaryColor
                                        : kWhiteColor,
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
                  // ------------ How stressed are you feeling? -------------

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: AppStyling.CUSTOM_CARD,
                    child: Column(
                      children: [
                        MyText(
                          text: 'How stressed are you feeling?',
                          size: 16,
                          paddingBottom: 20,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // ------------ Stressed Icons -------------

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            stressItems.length,
                            (index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    modeCtrl.stressedSelector(index);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                    (modeCtrl.stressIconHandler.value == index)
                                        ? stressItems[index]
                                            .selectedIcon // Highlighted icon
                                        : stressItems[index]
                                            .unselectedIcon, // Normal icon
                                    height: 44,
                                  ),

                                  MyText(
                                    paddingTop: 8,
                                    text: "${index}" , size: 12,color: kGreyColor2),
                                    ],
                                  )
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

                  // ------------ How irritable do you feel? -------------

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: AppStyling.CUSTOM_CARD,
                    child: Column(
                      children: [
                        MyText(
                          text: 'How irritable do you feel?',
                          size: 16,
                          paddingBottom: 20,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // ------- Irritable Icons ----------

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            irritateItems.length,
                            (index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    modeCtrl.irritableSelector(index);
                                  },
                                  child:

                                  Column(
                                    children: [
                                       Image.asset(
                                    (modeCtrl.irritateIconHandler.value ==
                                            index)
                                        ? irritateItems[index]
                                            .selectedIcon // Highlighted icon
                                        : irritateItems[index]
                                            .unselectedIcon, // Normal icon
                                    height: 44,
                                  ),


                                      MyText(
                                    paddingTop: 8,
                                    text: "${index}" , size: 12,color: kGreyColor2,),
                                    ],
                                  )
                                  
                                  
                                  
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
                                              separatorBuilder:
                                                  (context, index) {
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
                                                                    color: (ctrl.selectedEmojiTextModel.value ==
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
                        controller: modeCtrl.todayNoteController,
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
                    traillingWidget: Obx(
                      () => (modeCtrl.todayPhotos.length <= 2)
                          ? InkWell(
                              onTap: () {
                                // ------ Add Image into list ------

                                log('work');
                                modeCtrl.captureClientPhotos();
                              },
                              child: Image.asset(
                                Assets.imagesAddIcon,
                                height: 25,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    onMore: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 16,
                        ),

                        Obx(
                          () => (modeCtrl.todayPhotos.isNotEmpty)
                              ? Column(
                                  children: List.generate(
                                      modeCtrl.todayPhotos.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: (index == 0) ? 0 : 8),
                                    child: Container(
                                      height: 200,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                              image: FileImage(File(
                                                  modeCtrl.todayPhotos[index])),
                                              fit: BoxFit.cover)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // ------ Remove Image Button ------

                                          InkWell(
                                            onTap: () {
                                              modeCtrl
                                                  .removeCaptureClientPhotos(
                                                      index);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: kSecondaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                    )),
                                                child: Icon(
                                                  Icons.close,
                                                  color: kPrimaryColor,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    // CommonImageView(
                                    //   file: ,
                                    //   height: 200,
                                    //   width: Get.width,
                                    //   radius: 12,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  );

                                  // (index == 0)
                                  //     ?
                                  //     : CommonImageView(
                                  //         file: File(modeCtrl.todayPhotos[index]),
                                  //         height: 100,
                                  //         width: Get.width,
                                  //         radius: 12,
                                  //         fit: BoxFit.cover,
                                  //       );
                                }))
                              : CommonImageView(
                                  imagePath: Assets.imagesImagePlaceHolder2,
                                  height: 300,
                                  radius: 12,
                                  fit: BoxFit.cover,
                                ),
                        )
                        // : CommonImageView(
                        //     imagePath: Assets.imagesImagePlaceHolder2,
                        //     height: 300,
                        //     radius: 12,
                        //     fit: BoxFit.cover,
                        //   ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  // ------- Sleep --------

                  _CustomCard(
                    title: "Record Last Night's Sleep*",
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
                        onTap: () {
                          // ------ Starting & Ending Time Picker Bottom - Sheet ------

                          Get.bottomSheet(
                            isScrollControlled: true,
                            CustomBottomSheet(
                              height: Get.height * 0.6,
                              // height: 400,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: "Record your sleep",
                                          size: 16,
                                          weight: FontWeight.w600,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: kGreyColor2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => Column(
                                      children: [
                                        Padding(
                                          padding: AppSizes.HORIZONTAL,
                                          child: Row(
                                            children: [
                                              DisplayTime(
                                                width: (modeCtrl
                                                        .isStartingSleepRecordSelected
                                                        .value)
                                                    ? 2
                                                    : 0.5,
                                                borderColor: (modeCtrl
                                                        .isStartingSleepRecordSelected
                                                        .value)
                                                    ? kSecondaryColor
                                                    : kGreyColor2,
                                                time: (modeCtrl
                                                            .startSleepDuration
                                                            .value !=
                                                        null)
                                                    ? "${DateTimeService.instance.formatTimeToAMPM(modeCtrl.startSleepDuration.value)}"
                                                    : '-',
                                                onTap: () {
                                                  modeCtrl
                                                      .isStartingSleepRecordSelected
                                                      .value = true;
                                                },
                                              ),
                                              _Divider(),
                                              DisplayTime(
                                                width: (modeCtrl
                                                            .isStartingSleepRecordSelected
                                                            .value ==
                                                        false)
                                                    ? 2
                                                    : 0.5,
                                                borderColor: (modeCtrl
                                                            .isStartingSleepRecordSelected
                                                            .value ==
                                                        false)
                                                    ? kSecondaryColor
                                                    : kGreyColor2,
                                                time: (modeCtrl.endSleepDuration
                                                            .value !=
                                                        null)
                                                    ? "${DateTimeService.instance.formatTimeToAMPM(modeCtrl.endSleepDuration.value)}"
                                                    : '-',
                                                onTap: () {
                                                  modeCtrl
                                                      .isStartingSleepRecordSelected
                                                      .value = false;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        DobPicker(
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: (modeCtrl
                                                  .isStartingSleepRecordSelected
                                                  .value)
                                              ? modeCtrl
                                                  .startSleepDuration.value
                                              : modeCtrl.endSleepDuration.value,
                                          onDateTimeChanged: (dateTime) {
                                            if (modeCtrl
                                                .isStartingSleepRecordSelected
                                                .value) {
                                              modeCtrl.startSleepDuration
                                                  .value = dateTime;
                                              log("Starting Duration: ${modeCtrl.startSleepDuration.value}");
                                            } else {
                                              modeCtrl.endSleepDuration.value =
                                                  dateTime;
                                              log("End Duration: ${modeCtrl.endSleepDuration.value}");
                                            }
                                          },
                                          onTap: () {
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
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

            Obx(() {
              modeCtrl.isButtonEnabled.value =
                  modeCtrl.remainingTime.value <= 0;

              return Padding(
                padding: AppSizes.DEFAULT,
                child: MyButton(
                  bgColor: (modeCtrl.isButtonEnabled.value)
                      ? kSecondaryColor
                      : kGreyColor.withOpacity(0.6),
                  buttonText: (modeCtrl.isButtonEnabled.value)
                      ? 'Save Changes'
                      : "Time left: ${modeCtrl.formatDuration(Duration(milliseconds: modeCtrl.remainingTime.value))}",
                  onTap: () async {
                    if (modeCtrl.isButtonEnabled.value) {
                      modeCtrl.createBoard();

                      log('4');
                    } else {
                      log('sss ${modeCtrl.isButtonEnabled.value}');
                    }

                    // modeCtrl.uploadPhotosTOSorage();
                  },
                ),
              );
            }),

            // GetBuilder<ModeManagerController>(
            //   builder: (controller) {
            //     RxBool isButtonEnabled = false.obs;
            //     isButtonEnabled.value = controller.remainingTime.value <= 0;

            //     return ElevatedButton(
            //       onPressed:
            //           isButtonEnabled.value ? controller.createBoard : null,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:
            //             isButtonEnabled.value ? Colors.blue : Colors.grey,
            //       ),
            //       child: Text(
            //         isButtonEnabled.value
            //             ? "Enter Data"
            //             : "Wait: ${controller.formatDuration(Duration(milliseconds: controller.remainingTime.value))}",
            //       ),
            //     );
            //   },
            // )

            // GetBuilder<ModeManagerController>(builder: (ctrl) {
            //   bool isButtonEnabled = ctrl.remainingTime.value <= 0;

            //   return (isButtonEnabled)
            //       ? Padding(
            //           padding: AppSizes.DEFAULT,
            //           child: MyButton(
            //             buttonText: 'Save Changes',
            //             onTap: () async {
            //               modeCtrl.createBoard();
            //               await modeCtrl.displayCountdownForNextDataEntry();

            //               // modeCtrl.uploadPhotosTOSorage();
            //             },
            //           ),
            //         )
            //       : Padding(
            //           padding: AppSizes.DEFAULT,
            //           child: MyButton(
            //             bgColor: kGreyColor.withOpacity(0.6),
            //             buttonText:
            //                 "Wait: ${ctrl.formatDuration(Duration(milliseconds: ctrl.remainingTime.value))} ",
            //             onTap: () {},
            //           ),
            //         );
            // })

            // Padding(
            //   padding: AppSizes.DEFAULT,
            //   child: MyButton(
            //     buttonText: 'Save Changes',
            //     onTap: () {
            //       modeCtrl.createBoard();
            //       // modeCtrl.uploadPhotosTOSorage();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: kTertiaryColor,
      height: 1,
      width: 10,
    );
  }
}

// ignore: must_be_immutable
class DisplayTime extends StatelessWidget {
  String time;
  VoidCallback? onTap;
  Color borderColor;
  double width;
  DisplayTime(
      {super.key,
      this.time = '-',
      this.onTap,
      this.borderColor = kGreyColor2,
      this.width = 0.5});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 47,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: width, color: borderColor)),
          child: Center(
            child: MyText(
              text: '$time',
              size: 14,
              weight: FontWeight.w400,
              color: kTertiaryColor,
            ),
          ),
        ),
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
