import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/model/client_model/mood_models/block_model.dart';
import 'package:mood_prints/view/screens/client/customize_recording/mode_manager.dart';
import 'package:mood_prints/view/widget/alert_dialogs/delete_dialog.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_card_widget.dart';
import 'package:mood_prints/view/widget/emoji_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ActiveBlock extends StatefulWidget {
  const ActiveBlock({
    super.key,
  });

  @override
  State<ActiveBlock> createState() => _ActiveBlockState();
}

class _ActiveBlockState extends State<ActiveBlock> {
  int selectedFeeling = 0;
  final modeCtrl = Get.find<ModeManagerController>();

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

                // ----------> Create New Block Button <----------

                onTap: () {
                  Get.bottomSheet(
                    _CreateNewBlockBottomSheet(
                      textController: modeCtrl.commonTextController,

                      // ----------> On Bottom sheet Done button Tap <----------

                      onTap: () {
                        // ----------> Add new block into Local storage using getStorage <----------

                        String uniqueId =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        modeCtrl.addBlock(BlockModel(
                          id: uniqueId,
                          type: modeCtrl.commonTextController.text.trim(),
                          title: modeCtrl.commonTextController.text
                              .trim()
                              .toString(),
                        ));

                        modeCtrl.commonTextController.clear();
                        Get.back();

                        log('work');
                      },
                    ),
                    isScrollControlled: true,
                  );

                  //   String uniqueId =
                  // DateTime.now().millisecondsSinceEpoch.toString();

                  // modeCtrl.addWidget(BlockModel(
                  //     id: uniqueId,
                  //     type: "emotions",
                  //     title: 'Emotions',
                  //     data: [
                  //       {'emoji': '😁', 'text': 'Proud'},
                  //       {'emoji': '😢', 'text': 'Sad'},
                  //       {'emoji': '😡', 'text': 'Fear'},
                  //     ]));
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
                        stressItems.length,
                        (index) {
                          return InkWell(
                            child: Image.asset(
                              stressItems[index].unselectedIcon,
                              height: 44,
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

              // ------------------ Creating New Block Widegts -------------------

              Container(
                  child: Obx(() => (modeCtrl.activeWidgets.isNotEmpty)
                      ? Column(
                          children: List.generate(modeCtrl.activeWidgets.length,
                              (headIndex) {
                            return Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: GetBuilder<ModeManagerController>(
                                  builder: (controller) {
                                    return CustomCard(
                                      title:
                                          '${modeCtrl.activeWidgets[headIndex].title}',
                                      onEdit: () {
                                        // ------- Crud Operations -------
                                        Get.bottomSheet(EditBottomSheet(
                                          title: modeCtrl
                                              .activeWidgets[headIndex].title,

                                          // ---- Edit Block Name Button ----

                                          onEditBlockNameTap: () {
                                            log('work');
                                            modeCtrl.commonTextController.text =
                                                modeCtrl
                                                    .activeWidgets[headIndex]
                                                    .title;

                                            Get.bottomSheet(
                                              _EditBlockNameBottomSheet(
                                                onTap: () {
                                                  modeCtrl.updateBlockTitle(
                                                      headIndex,
                                                      modeCtrl
                                                          .commonTextController
                                                          .text);
                                                  Get.close(2);

                                                  modeCtrl.commonTextController
                                                      .clear();
                                                },
                                                editBlockNameController:
                                                    modeCtrl
                                                        .commonTextController,
                                              ),
                                              isScrollControlled: true,
                                            );
                                          },

                                          // ---- Hide Button ----

                                          onHideORUnHideTap: () {
                                            modeCtrl.hideBlock(headIndex);
                                            Get.back();
                                          },

                                          // ---- Delete Button ----

                                          onDeleteTap: () {
                                            modeCtrl.deleteBlockFromActive(
                                                headIndex);
                                            Get.close(2);
                                          },
                                        ));
                                      },
                                      onMore: () {
                                        log('work');
                                      },

                                      // The Emotions Widgets

                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          children: [
                                            // ----- Nested List to display icons & text

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
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      // emotionsItems.length + 1,
                                                      modeCtrl
                                                              .activeWidgets[
                                                                  headIndex]
                                                              .data
                                                              .length +
                                                          1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    // if (index ==
                                                    //     modeCtrl
                                                    //         .activeWidgets[
                                                    //             headIndex]
                                                    //         .data
                                                    //         .isNotEmpty) {
                                                    //   return AddMoreEmojiButton(
                                                    //     onTap: () {
                                                    //       log(" Add Button Index : ${modeCtrl.activeWidgets[headIndex].data.length}");
                                                    //       log("-----> Add More List is Empty");

                                                    //       // ----- Icon & Name Bottom Sheet -----

                                                    //       Get.bottomSheet(
                                                    //           _IconNameBottomSheet(
                                                    //         index: headIndex,
                                                    //         blockName: modeCtrl
                                                    //             .activeWidgets[
                                                    //                 index]
                                                    //             .title,
                                                    //       ));
                                                    //     },
                                                    //   );
                                                    // }

                                                    // ---------- Add more emojis button in the last index ------------

                                                    if (index ==
                                                        modeCtrl
                                                            .activeWidgets[
                                                                headIndex]
                                                            .data
                                                            .length) {
                                                      return AddMoreEmojiButton(
                                                        onTap: () {
                                                          log("Add More");
                                                          Get.bottomSheet(
                                                              _IconNameBottomSheet(
                                                            index: headIndex,
                                                            blockName: modeCtrl
                                                                .activeWidgets[
                                                                    headIndex]
                                                                .title,
                                                          ));
                                                        },
                                                      );
                                                    } else {
                                                      // ---------- Emojis & Text ------------

                                                      return SizedBox(
                                                        height: Get.height,
                                                        // width: 44,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height: 44,
                                                              width: 44,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    kLightGreyColor,
                                                              ),
                                                              child: Center(
                                                                child: MyText(
                                                                  // text: modeCtrl
                                                                  //     .activeWidgets[
                                                                  //         headIndex]
                                                                  //     .data[
                                                                  //         index]
                                                                  //     .emoji
                                                                  text:
                                                                      '${modeCtrl.activeWidgets[headIndex].data[index].emoji}',

                                                                  size: 24,
                                                                ),
                                                              ),
                                                            ),
                                                            MyText(
                                                              text: modeCtrl
                                                                  .activeWidgets[
                                                                      headIndex]
                                                                  .data[index]
                                                                  .text
                                                                  .toString(),
                                                              // '${emotionsItems[index]['text']}',
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ));
                          }),
                        )
                      : SizedBox.shrink())),

              SizedBox(
                height: 12,
              ),
              CustomCard(
                title: 'Today’s note*',
                haveEditButton: false,
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
                haveEditButton: false,
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
                haveEditButton: false,
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

        // -------------- Save Changes Button -----------------

        Padding(
          padding: AppSizes.DEFAULT,
          child: MyButton(
            buttonText: 'Save Changes',
            onTap: () {
              modeCtrl.saveBlocks();
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}

class _IconNameBottomSheet extends StatelessWidget {
  final String blockName;
  final int index;

  _IconNameBottomSheet({
    super.key,
    required this.blockName,
    required this.index,
  });

  final modeCtrl = Get.find<ModeManagerController>();

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
                // onTap: () {
                //   Get.back();
                // },
                child: Container(
                    color: kPrimaryColor,
                    child: SizedBox(width: 20, height: 20)),
              ),
              MyText(
                text: '$blockName',
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
                // ---- Emoji Picker ----

                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(EmojiCustomWidget(
                              onEmojiSelected: (category, emoji) {
                            modeCtrl.selectedEmoji.value = emoji.emoji;
                            Get.back();
                            log("Selected Emoji: $modeCtrl.selectedEmoji.value");
                          }));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kLightGreyColor,
                          ),
                          child: Center(
                            child: Obx(
                              () => MyText(
                                text: (modeCtrl.selectedEmoji.isNotEmpty)
                                    ? '${modeCtrl.selectedEmoji.value}'
                                    : '🌼',
                                size: 24,
                              ),
                            ),
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
                  controller: modeCtrl.commonTextController,
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
              modeCtrl.addNewEmojiAndTitleToList(
                  newEmoji: modeCtrl.selectedEmoji.value,
                  newTitle: modeCtrl.commonTextController.text.trim(),
                  mainIndex: index);
              Get.back();
              modeCtrl.selectedEmoji.value = '';
              modeCtrl.commonTextController.clear();

              log('My Done Button WOrks');
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _CreateNewBlockBottomSheet extends StatelessWidget {
  final VoidCallback? onTap;
  TextEditingController? textController = TextEditingController();
  _CreateNewBlockBottomSheet({super.key, this.onTap, this.textController});

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
                  controller: textController,
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
            buttonText: 'Done', onTap: onTap,

            // Get.to(() => NewBlockAdded());
          ),
        ],
      ),
    );
  }
}

class EditBottomSheet extends StatelessWidget {
  final VoidCallback? onHideORUnHideTap;
  final VoidCallback? onDeleteTap;
  final String? commonButtonText;
  final String? title;
  final VoidCallback? onEditBlockNameTap;

  EditBottomSheet({
    super.key,
    this.onHideORUnHideTap,
    this.commonButtonText,
    this.title,
    this.onDeleteTap,
    this.onEditBlockNameTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
                text: title ?? 'Catagory Name',
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
            height: 20,
          ),
          MyText(
            onTap: onEditBlockNameTap,
            text: 'Edit block name',
            paddingBottom: 20,
          ),
          MyText(
            onTap: onHideORUnHideTap,
            text: commonButtonText ?? 'Hide from recording page',
            paddingBottom: 20,
          ),
          MyText(
            onTap: () {
              Get.dialog(DeleteDialog(
                onDeleteTap: onDeleteTap,
              ));
            },
            text: 'Delete',
            paddingBottom: 20,
            color: kRedColor,
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _EditBlockNameBottomSheet extends StatelessWidget {
  TextEditingController? editBlockNameController = TextEditingController();
  final VoidCallback? onTap;
  _EditBlockNameBottomSheet(
      {super.key, this.onTap, this.editBlockNameController});

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
                  controller: editBlockNameController,
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
          MyButton(buttonText: 'Done', onTap: onTap),
        ],
      ),
    );
  }
}
