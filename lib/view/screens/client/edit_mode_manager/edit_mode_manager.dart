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
import 'package:mood_prints/model/board_model/all_%20board.dart';
import 'package:mood_prints/model/board_model/board_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/screens/client/customize_recording/mode_manager.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class EditModeManager extends StatefulWidget {
  BoardEntry model;

  EditModeManager({super.key, required this.model});

  @override
  State<EditModeManager> createState() => _EditModeManagerState();
}

class _EditModeManagerState extends State<EditModeManager> {
  final ctrl = Get.find<ModeManagerController>();

  @override
  void dispose() {
    super.dispose();
    ctrl.clearBoardEntries();
  }

  void showDatePickerOnTitleTap() {
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
                    initialDateTime: ctrl.datePicker.value,
                    onDateTimeChanged: (dateTime) {
                      ctrl.dateTime = dateTime;
                    },
                    onTap: () {
                      if (ctrl.dateTime != null) {
                        ctrl.datePicker.value = ctrl.dateTime!;
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
    ctrl.datePicker.value = widget.model.date;
    ctrl.stressIconHandler.value = 0;
    ctrl.stressLevel = widget.model.stressLevel;
    ctrl.todayNoteController.text = widget.model.note;
    ctrl.todayPhotos.value = widget.model.photos!;
    log("photo Length: ${ctrl.todayPhotos.length}");

    return Obx(
      () => Scaffold(
        appBar: simpleAppBar(
          title:
              '${DateTimeService.instance.getSimpleUSDateFormat(ctrl.datePicker.value)}',
          onTitleTap: showDatePickerOnTitleTap,
        ),
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
                                      ctrl.selectedMood.value =
                                          modeIndicatorItems[index];

                                      log('selected Model:=> ${ctrl.selectedMood.value.toMap().toString()} ');
                                      // currentModeIndex = index;
                                      // log(currentModeIndex.toString());
                                    },
                                    child: Icon(
                                      ((ctrl.selectedMood.value ==
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
                              // color: modeIndicatorItems[currentModeIndex].color,
                              color: ctrl.selectedMood.value.color,
                            ),
                            child: Center(
                              child: MyText(
                                text:
                                    // "${modeIndicatorItems[currentModeIndex].mode} Mode",
                                    "${ctrl.selectedMood.value.mode} Mode",
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

                        // ------- Emotions ----------

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            feelingItems.length,
                            (index) {
                              ctrl.stressIconHandler.value =
                                  feelingItems.indexWhere((item) =>
                                      item.stressLevel == ctrl.stressLevel);

                              // log("finding Index: ${stressLevelIndex}");

                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    ctrl.emotionSelector(index);
                                    // stressLevelIndex = index;
                                  },
                                  child: Image.asset(
                                    (ctrl.stressIconHandler.value == index)
                                        ? feelingItems[index]
                                            .iconA // Highlighted icon
                                        : feelingItems[index]
                                            .iconB, // Normal icon
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

                  (ctrl.activeWidgets.isNotEmpty)
                      ? Column(
                          children: List.generate(ctrl.activeWidgets.length,
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
                        controller: ctrl.todayNoteController,
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
                      () => (ctrl.todayPhotos.length <= 2)
                          ? InkWell(
                              onTap: () {
                                // ------ Add Image into list ------

                                log('work');
                                ctrl.captureClientPhotos();
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
                          () => (ctrl.todayPhotos.isNotEmpty)
                              ? Column(
                                  children: List.generate(
                                      ctrl.todayPhotos.length, (index) {
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
                                              image: NetworkImage(
                                                  ctrl.todayPhotos[index]))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // ------ Remove Image Button ------

                                          InkWell(
                                            onTap: () {
                                              ctrl.todayPhotos.removeAt(index);
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
                                  );
                                }))
                              : CommonImageView(
                                  imagePath: Assets.imagesImagePlaceHolder2,
                                  height: 300,
                                  radius: 12,
                                  fit: BoxFit.cover,
                                ),
                        )
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
                                                width: (ctrl
                                                        .isStartingSleepRecordSelected
                                                        .value)
                                                    ? 2
                                                    : 0.5,
                                                borderColor: (ctrl
                                                        .isStartingSleepRecordSelected
                                                        .value)
                                                    ? kSecondaryColor
                                                    : kGreyColor2,
                                                time: (ctrl.startSleepDuration
                                                            .value !=
                                                        null)
                                                    ? "${DateTimeService.instance.formatTimeToAMPM(ctrl.startSleepDuration.value)}"
                                                    : '-',
                                                onTap: () {
                                                  ctrl.isStartingSleepRecordSelected
                                                      .value = true;
                                                },
                                              ),
                                              _Divider(),
                                              DisplayTime(
                                                width:
                                                    (ctrl.isStartingSleepRecordSelected
                                                                .value ==
                                                            false)
                                                        ? 2
                                                        : 0.5,
                                                borderColor:
                                                    (ctrl.isStartingSleepRecordSelected
                                                                .value ==
                                                            false)
                                                        ? kSecondaryColor
                                                        : kGreyColor2,
                                                time: (ctrl.endSleepDuration
                                                            .value !=
                                                        null)
                                                    ? "${DateTimeService.instance.formatTimeToAMPM(ctrl.endSleepDuration.value)}"
                                                    : '-',
                                                onTap: () {
                                                  ctrl.isStartingSleepRecordSelected
                                                      .value = false;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        DobPicker(
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: (ctrl
                                                  .isStartingSleepRecordSelected
                                                  .value)
                                              ? ctrl.startSleepDuration.value
                                              : ctrl.endSleepDuration.value,
                                          onDateTimeChanged: (dateTime) {
                                            if (ctrl
                                                .isStartingSleepRecordSelected
                                                .value) {
                                              ctrl.startSleepDuration.value =
                                                  dateTime;
                                              log("Starting Duration: ${ctrl.startSleepDuration.value}");
                                            } else {
                                              ctrl.endSleepDuration.value =
                                                  dateTime;
                                              log("End Duration: ${ctrl.endSleepDuration.value}");
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

            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Update Changes',
                onTap: () {
                  // modeCtrl.createBoard();
                },
              ),
            ),
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
