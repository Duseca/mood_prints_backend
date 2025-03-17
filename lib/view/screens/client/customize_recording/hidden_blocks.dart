import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/view/widget/alert_dialogs/delete_dialog.dart';
import 'package:mood_prints/view/widget/custom_card_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class HiddenBlocks extends StatelessWidget {
  HiddenBlocks({
    super.key,
  });

  final modeCtrl = Get.find<ModeManagerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: AppSizes.DEFAULT,
          child: Obx(
            () => (modeCtrl.hiddenWidgets.isNotEmpty)
                ? Column(
                    children: List.generate(modeCtrl.hiddenWidgets.length,
                        (headIndex) {
                      return Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: CustomCard(
                            title: '${modeCtrl.hiddenWidgets[headIndex].title}',
                            onEdit: () {
                              // ------- Crud Operations -------
                              Get.bottomSheet(_EditBottomSheetForHidden(
                                title: modeCtrl.hiddenWidgets[headIndex].title
                                    .toString(),
                                onHideORUnHideTap: () {
                                  modeCtrl.unhideBlock(headIndex);
                                  Get.back();
                                },
                                onDeleteTap: () {
                                  modeCtrl.deleteBlockFromHidden(
                                    headIndex,
                                  );
                                  Get.close(2);
                                },
                              ));
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
                                        itemCount: modeCtrl
                                            .hiddenWidgets[headIndex]
                                            .data
                                            .length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: Get.height,
                                            width: 44,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      text:
                                                          '${modeCtrl.hiddenWidgets[headIndex].data[index].emoji}',
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                                MyText(
                                                  maxLines: 1,
                                                    textOverflow: TextOverflow.ellipsis,

                                                  text:
                                                      '${'${modeCtrl.hiddenWidgets[headIndex].data[index].text.trim()}'}',
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
                            )),
                      );
                    }),
                  )
                : Center(
                    child: MyText(
                      text: 'No Hidden Blocks',
                    ),
                  ),
          )),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Save Changes',
          onTap: () {
            modeCtrl.saveBlocks();
            Get.back();

            // Get.to(() => CustomizeRecording());
          },
        ),
      ),
    );
  }
}

class _EditBottomSheetForHidden extends StatelessWidget {
  final VoidCallback? onHideORUnHideTap;
  final VoidCallback? onDeleteTap;

  final String? title;

  _EditBottomSheetForHidden({
    super.key,
    this.onHideORUnHideTap,
    this.title,
    this.onDeleteTap,
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
            height: 40,
          ),
          MyText(
            onTap: onHideORUnHideTap,
            text: 'Unhide from the hidden page."',
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
