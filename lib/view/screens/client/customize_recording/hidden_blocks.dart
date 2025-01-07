import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/mode_manager/mode_manager_controller.dart';
import 'package:mood_prints/view/screens/client/customize_recording/active_block.dart';
import 'package:mood_prints/view/screens/client/customize_recording/customize_recording.dart';
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
      body: Column(
        children: [
          Container(
              padding: AppSizes.DEFAULT,
              child: Obx(
                () => (modeCtrl.hiddenWidgets.isNotEmpty)
                    ? Column(
                        children: List.generate(modeCtrl.hiddenWidgets.length,
                            (index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: CustomCard(
                                title: '${modeCtrl.hiddenWidgets[index].title}',
                                onEdit: () {
                                  // ------- Crud Operations -------
                                  Get.bottomSheet(EditBottomSheet(
                                    title: modeCtrl.hiddenWidgets[index].title
                                        .toString(),
                                    commonButtonText: 'UnHide',
                                    onHideORUnHideTap: () {
                                      modeCtrl.unhideBlock(index);
                                    },
                                    onDeleteTap: () {
                                      modeCtrl.deleteBlock(index);
                                      Get.back();
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
                                            itemCount: 2,
                                            itemBuilder: (context, index) {
                                              if (index == 1) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    // Get.bottomSheet(
                                                    //   _IconNameBottomSheet(),
                                                    //   isScrollControlled: true,
                                                    // );
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
                                )),
                          );
                        }),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Align(
                              alignment: Alignment.center,
                              child: MyText(
                                text: 'No Hidden Blocks',
                              ),
                            ),
                          ),
                        ],
                      ),
              ))

          // Expanded(
          //   child: ListView(
          //     shrinkWrap: true,
          //     physics: BouncingScrollPhysics(),
          //     padding: AppSizes.DEFAULT,
          //     children: [
          //       CustomCard(
          //         title: 'Feeling',
          //         onEdit: () {},
          //         onMore: () {
          //           Get.dialog(DeleteDialog());
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 16),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: SizedBox(
          //                   height: 62,
          //                   child: ListView.separated(
          //                     separatorBuilder: (context, index) {
          //                       return SizedBox(
          //                         width: 16,
          //                       );
          //                     },
          //                     shrinkWrap: true,
          //                     padding: EdgeInsets.zero,
          //                     physics: BouncingScrollPhysics(),
          //                     scrollDirection: Axis.horizontal,
          //                     itemCount: 10,
          //                     itemBuilder: (context, index) {
          //                       return SizedBox(
          //                         height: Get.height,
          //                         width: 44,
          //                         child: Column(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Container(
          //                               height: 44,
          //                               width: 44,
          //                               decoration: BoxDecoration(
          //                                 shape: BoxShape.circle,
          //                                 color: kLightGreyColor,
          //                               ),
          //                               child: Center(
          //                                 child: MyText(
          //                                   text: '😁',
          //                                   size: 24,
          //                                 ),
          //                               ),
          //                             ),
          //                             MyText(
          //                               text: 'Proud',
          //                               size: 12,
          //                             ),
          //                           ],
          //                         ),
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 12,
          //       ),
          //       CustomCard(
          //         title: 'Health',
          //         onEdit: () {},
          //         onMore: () {},
          //         child: SizedBox(),
          //       ),
          //       SizedBox(
          //         height: 12,
          //       ),
          //       CustomCard(
          //         title: 'Self-Care',
          //         onEdit: () {},
          //         onMore: () {},
          //         child: SizedBox(),
          //       ),
          //       SizedBox(
          //         height: 12,
          //       ),
          //       CustomCard(
          //         title: 'Exercise',
          //         onEdit: () {
          //           Get.bottomSheet(
          //             EditBottomSheet(),
          //             isScrollControlled: true,
          //             backgroundColor: Colors.transparent,
          //           );
          //         },
          //         onMore: () {},
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.stretch,
          //           children: [
          //             SizedBox(
          //               height: 16,
          //             ),
          //             MyBorderButton(
          //               buttonText: '',
          //               buttonColor: kBorderColor,
          //               bgColor: kOffWhiteColor,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Image.asset(
          //                     Assets.imagesDropIcon,
          //                     height: 20,
          //                   ),
          //                   MyText(
          //                     paddingLeft: 8,
          //                     paddingRight: 8,
          //                     text: 'Record your exercise',
          //                     size: 14,
          //                     color: kGreyColor,
          //                     weight: FontWeight.w500,
          //                   ),
          //                 ],
          //               ),
          //               onTap: () {},
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ,
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Save Changes',
          onTap: () {
            Get.to(() => CustomizeRecording());
          },
        ),
      ),
    );
  }
}
