import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/model/stats/mode_flow_stats_model.dart';
import 'package:mood_prints/model/stats/emotion_stats_model.dart';
import 'package:mood_prints/model/stats/mood_by_sleep.dart';
import 'package:mood_prints/view/screens/client/client_stats/client_stats.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mood_prints/model/stats/sleep_analysis_model.dart';

class Report extends StatefulWidget {
  String? clientID;
  Report({super.key, required this.clientID});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var ctrl = Get.find<ClientHomeController>();

  @override
  void initState() {
    super.initState();
    log("--------- Init Called -------- ${widget.clientID}");
    ctrl.allStats(userID: widget.clientID);
  }

  // final List<DateWiseStressStats> stats = modeStatsModel.dateWiseStressStats ?? [];
  @override
  Widget build(BuildContext context) {
    final List<String> _items = [
      'Weekly',
      'Monthly',
    ];
    final List<Widget> _tabBarView = [
      _Weekly(
        clientID: widget.clientID,
      ),
      _Monthly(),
    ];
    return DefaultTabController(
      length: _items.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: simpleAppBar(
          title: 'Stats',
          centerTitle: false,
          haveLeading: true,
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.dialog(
                    _ExportData(),
                  );
                },
                child: Image.asset(
                  Assets.imagesExportData,
                  height: 20,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelColor: kSecondaryColor,
              unselectedLabelColor: kGreyColor,
              indicatorColor: kSecondaryColor,
              automaticIndicatorColorAdjustment: false,
              indicatorWeight: 2,
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.URBANIST,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.URBANIST,
              ),
              tabs: _items.map(
                (e) {
                  return Tab(
                    text: e,
                  );
                },
              ).toList(),
              onTap: (index) {
                log("$index");
                if (index == 1) {
                  ctrl.allmonthlyStats(userID: widget.clientID);

                  setState(() {});
                }
              },
            ),
            Expanded(
              child: TabBarView(
                children: _tabBarView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportData extends StatelessWidget {
  const _ExportData({
    super.key,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Export Data',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            paddingTop: 6,
                            text: 'Choose which stats info they can view?',
                            size: 13,
                            color: kGreyColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: kGreyColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  color: kBorderColor,
                  margin: EdgeInsets.symmetric(vertical: 16),
                ),
                ...List.generate(
                  5,
                  (index) {
                    final List<String> _items = [
                      'Mood Flow',
                      'Mood Bar',
                      'Emotion',
                      'Sleep Analysis',
                      'Moods by Sleep',
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          CustomCheckBox(
                            isActive: index == 0,
                            onTap: () {},
                          ),
                          Expanded(
                            child: MyText(
                              text: _items[index],
                              paddingLeft: 10,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                  buttonText: 'Export as PDF',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ----------- Weekly ------------
class _Weekly extends StatefulWidget {
  final String? clientID;
  _Weekly({super.key, this.clientID});

  @override
  State<_Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<_Weekly> {
  // EmotionStatsModel? model;
  EmotionStatsModel? stats;

  List<String> weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  // List<Month> months = [
  //   Month(name: "January", number: 1),
  //   Month(name: "February", number: 2),
  //   Month(name: "March", number: 3),
  //   Month(name: "April", number: 4),
  //   Month(name: "May", number: 5),
  //   Month(name: "June", number: 6),
  //   Month(name: "July", number: 7),
  //   Month(name: "August", number: 8),
  //   Month(name: "September", number: 9),
  //   Month(name: "October", number: 10),
  //   Month(name: "November", number: 11),
  //   Month(name: "December", number: 12),
  // ];

  @override
  Widget build(BuildContext context) {
    var ctrl = Get.find<ClientHomeController>();
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 120),
      physics: BouncingScrollPhysics(),
      children: [
        // ----- Week Selector Button ----------

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => GestureDetector(
              onTap: () async {
                ctrl.weekFrontUpdate.value = index;
                ctrl.weekIndex.value = index + 1;
                log("${ctrl.weekIndex.value}");

                showLoadingDialog();
                await ctrl.allStats(userID: widget.clientID);
                hideLoadingDialog();
                setState(() {});
              },
              child: Obx(
                () => Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border.all(
                          color: (ctrl.weekFrontUpdate == index)
                              ? kSecondaryColor
                              : kWhiteColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(child: MyText(text: '${weeks[index]}')),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Select Month',
              paddingBottom: 15,
            ),
            // SizedBox(
            //   width: 100,
            //   child: CustomDropDown(
            //       hint: 'Month',
            //       items: months,
            //       selectedValue: 'Jan',
            //       onChanged: (v) {}),
            // )
          ],
        ),
// ----------- Mode Flow Card ------------

        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Mood Flow',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 17),
                      child: Transform(
                        alignment: Alignment.center, // Flip around the center
                        transform: Matrix4.rotationX(
                            3.14159), // Flip vertically (bottom to top)
                        child: Image.asset(
                          Assets.imagesColorDots,
                          height: 210,
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),

                  // ------- Model Flow Chat ------

                  Expanded(
                    child: _MoodFlowChart(
                      // stats: ctrl.moodFlowStats,
                      stats: ctrl.moodFlowStats,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              (ctrl.moodFlowStats != null)
                  ? SizedBox.shrink()
                  : RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: kTertiaryColor,
                          fontFamily: AppFonts.URBANIST,
                        ),
                        children: [
                          TextSpan(
                            text: 'Mood Patterns: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'No data available. ',
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),

        // ---------- Mood Bar // Emotion ----------

        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            children: [
              MyText(
                text: 'Mood Bar',
                size: 16,
                paddingBottom: 20,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              // Wrap(
              //   alignment: WrapAlignment.center,
              //   spacing: 10,
              //   runSpacing: 10,
              //   children: List.generate(
              //     feelingItems.length,
              //     (index) {

              //       String stressLevel =
              //           feelingItems[index].stressLevel.toString();

              //       String? percentage =
              //           ctrl.emotionPercentageStats?.firstWhere(
              //         (item) =>
              //             item.stressLevel ==
              //             stressLevel, // Compare stressLevel directly
              //         orElse: () => StressLevelPercentage(
              //             stressLevel: null,
              //             percentage: null), // Return a fallback object
              //       ).toString();

              //       log('percentage : $percentage');

              //       return Column(
              //         children: [
              //           Image.asset(
              //             feelingItems[index].iconA,
              //             height: 44,
              //           ),
              //           SizedBox(
              //             height: 8,
              //           ),
              //           // padding: EdgeInsets.symmetric(
              //           //       horizontal: 12,
              //           //       vertical: 3,
              //           //     ),

              //           SizedBox(
              //             width: 60,
              //             child: LinearPercentIndicator(
              //               width: 60,
              //               lineHeight: 14.0,
              //               percent: 50 / 100,
              //               backgroundColor: kGreyColor3,
              //               progressColor: kSecondaryColor,
              //               barRadius: Radius.circular(100),
              //             ),

              //             // LinearProgressIndicator(
              //             //   minHeight: 20,
              //             //   borderRadius: BorderRadius.circular(100),
              //             //   backgroundColor: kGreyColor3,
              //             //   value: 0.9,
              //             // )
              //           )
              //           // Container(
              //           //   padding: EdgeInsets.symmetric(
              //           //     horizontal: 12,
              //           //     vertical: 3,
              //           //   ),
              //           //   decoration: BoxDecoration(
              //           //     color:
              //           //         index == 0 ? kSecondaryColor : kOffWhiteColor,
              //           //     borderRadius: BorderRadius.circular(50),
              //           //   ),
              //           //   child: MyText(
              //           //     text: '4%',
              //           //     size: 12,
              //           //     color: index == 0 ? kWhiteColor : kGreyColor,
              //           //   ),
              //           // ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              // With Progress bar -----------

              // Wrap(
              //   alignment: WrapAlignment.center,
              //   spacing: 10,
              //   runSpacing: 10,
              //   children: List.generate(
              //     feelingItems.length,
              //     (index) {
              //       // Extract stress level for the current item
              //       String stressLevel =
              //           feelingItems[index].stressLevel.toString();

              //       // Safely get the percentage for the current stress level
              //       String? percentage = ctrl.emotionPercentageStats
              //           ?.firstWhere(
              //             (item) => item.stressLevel == stressLevel,
              //             orElse: () => StressLevelPercentage(
              //                 stressLevel: null, percentage: null),
              //           )
              //           .percentage;

              //       log('Stress Level: $stressLevel, Percentage: $percentage');

              //       // Convert percentage to a double for the progress bar
              //       double progressValue = (percentage != null)
              //           ? double.tryParse(percentage.replaceAll('%', '')) ?? 0.0
              //           : 0.0;

              //       return Column(
              //         children: [
              //           // Display iconA if percentage exists, otherwise iconB
              //           Image.asset(
              //             percentage != null
              //                 ? feelingItems[index].iconA
              //                 : feelingItems[index].iconB,
              //             height: 44,
              //           ),
              //           const SizedBox(height: 8),

              //           // LinearPercentIndicator with percentage text in the center
              //           SizedBox(
              //             width: 60,
              //             child: Stack(
              //               alignment: Alignment
              //                   .center, // Center the text inside the progress bar
              //               children: [
              //                 LinearPercentIndicator(
              //                   width: 60,
              //                   lineHeight: 14.0,
              //                   percent: (progressValue / 100).clamp(0.0, 1.0),
              //                   backgroundColor: kGreyColor3,
              //                   progressColor: kSecondaryColor,
              //                   barRadius: const Radius.circular(100),
              //                 ),
              //                 Text(
              //                   percentage != null ? percentage : "0%",

              //                   style: const TextStyle(
              //                     fontSize: 10,
              //                     color: Colors.black,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  stressItems.length,
                  (index) {
                    // Extract stress level for the current item
                    String stressLevel = stressItems[index].level.toString();

                    // Safely get the percentage for the current stress level
                    String? percentage = ctrl.emotionPercentageStats
                        ?.firstWhere(
                          (item) => item.stressLevel == stressLevel,
                          orElse: () => StressLevelPercentage(
                              stressLevel: null, percentage: null),
                        )
                        .percentage;

                    // log('Stress Level: $stressLevel, Percentage: $percentage');

                    return Column(
                      children: [
                        // Display iconA if percentage exists, otherwise iconB
                        Image.asset(
                          percentage != null
                              ? stressItems[index].selectedIcon
                              : stressItems[index].unselectedIcon,
                          height: 44,
                        ),
                        const SizedBox(height: 8),

                        // Progress bar using Container with text
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background bar
                            Container(
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                color: (percentage != null)
                                    ? kSecondaryColor
                                    : kGreyColor3,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            // Foreground bar for progress
                            // if (percentage != null)
                            //   Container(
                            //     width: (60 *
                            //             (double.tryParse(percentage.replaceAll(
                            //                     '%', '')) ??
                            //                 0.0) /
                            //             100)
                            //         .clamp(0.0, 60.0),
                            //     height: 14,
                            //     decoration: BoxDecoration(
                            //       color: kSecondaryColor,
                            //       borderRadius: BorderRadius.circular(100),
                            //     ),
                            //   ),
                            // Centered text showing percentage
                            MyText(
                              text: percentage ?? '0%',
                              size: 12,
                              color:
                                  percentage != null ? kWhiteColor : kGreyColor,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        // Container(
        //   padding: EdgeInsets.all(20),
        //   decoration: AppStyling.CUSTOM_CARD,
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           MyText(
        //             text: 'Emotions',
        //             size: 16,
        //             weight: FontWeight.w600,
        //             textAlign: TextAlign.center,
        //           ),
        //           Image.asset(
        //             Assets.imagesArrowNext,
        //             height: 24,
        //             color: kGreyColor,
        //           ),
        //         ],
        //       ),
        //       SizedBox(
        //         height: 16,
        //       ),
        //       GridView.builder(
        //         shrinkWrap: true,
        //         padding: EdgeInsets.zero,
        //         physics: BouncingScrollPhysics(),
        //         itemCount: 3,
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 3,
        //           crossAxisSpacing: 10,
        //           mainAxisSpacing: 10,
        //           mainAxisExtent: 150,
        //         ),
        //         itemBuilder: (context, index) {
        //           return Container(
        //             padding: EdgeInsets.symmetric(
        //               horizontal: 12,
        //               vertical: 10,
        //             ),
        //             margin: EdgeInsets.symmetric(
        //               vertical: 10,
        //             ),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               color: kWhiteColor,
        //               boxShadow: [
        //                 BoxShadow(
        //                   offset: Offset(0, 4),
        //                   blurRadius: 10,
        //                   color: kTertiaryColor.withOpacity(0.1),
        //                 ),
        //               ],
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 MyText(
        //                   text: '${index + 1}',
        //                   size: 12,
        //                   weight: FontWeight.w600,
        //                 ),
        //                 Container(
        //                   height: 44,
        //                   width: 44,
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     color: kLightGreyColor,
        //                   ),
        //                   child: Center(
        //                     child: MyText(
        //                       text: '😁',
        //                       size: 24,
        //                     ),
        //                   ),
        //                 ),
        //                 MyText(
        //                   paddingTop: 8,
        //                   paddingBottom: 6,
        //                   text: 'Proud',
        //                   size: 12,
        //                   textAlign: TextAlign.center,
        //                   weight: FontWeight.w600,
        //                 ),
        //                 MyText(
        //                   textAlign: TextAlign.center,
        //                   text: 'x1',
        //                   size: 12,
        //                   color: kGreyColor,
        //                 ),
        //               ],
        //             ),
        //           );
        //         },
        //       ),
        //       SizedBox(
        //         height: 16,
        //       ),
        //       RichText(
        //         text: TextSpan(
        //           style: TextStyle(
        //             color: kTertiaryColor,
        //             fontFamily: AppFonts.URBANIST,
        //           ),
        //           children: [
        //             TextSpan(
        //               text: 'You recorded',
        //             ),
        //             TextSpan(
        //               text: ' Excited ',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.w600,
        //                 color: kSecondaryColor,
        //               ),
        //             ),
        //             TextSpan(
        //               text: 'the most.',
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Sleep Analysis',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Bedtime',
                            size: 12,
                            color: kGreyColor,
                          ),

                          // ------ Average Bed Time -------
                          MyText(
                            paddingTop: 4,
                            text:
                                '${ctrl.sleepAnalysisModel.value?.averageBedtime}',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Wake Up',
                            size: 12,
                            color: kGreyColor,
                          ),
                          MyText(
                            paddingTop: 4,
                            text:
                                '${ctrl.sleepAnalysisModel.value?.averageWakeupTime}',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              // --------- Sleep Duration Graph ------------

              SleepAnalysis(
                  // sleepStats: ctrl.sleepStats,
                  ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(
              //       width: 1.0,
              //       color: kBorderColor,
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Image.asset(
              //             Assets.imagesOrange,
              //             height: 16,
              //           ),
              //           Expanded(
              //             child: MyText(
              //               paddingLeft: 8,
              //               text: 'Less than 6h',
              //               size: 14,
              //               color: kGreyColor,
              //             ),
              //           ),
              //           MyText(
              //             paddingLeft: 8,
              //             text: '65 / 31 days',
              //             size: 14,
              //             color: kGreyColor,
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 12,
              //       ),
              //       Row(
              //         children: [
              //           Image.asset(
              //             Assets.imagesLightGreen,
              //             height: 16,
              //           ),
              //           Expanded(
              //             child: MyText(
              //               paddingLeft: 8,
              //               text: '6-8h',
              //               size: 14,
              //               color: kGreyColor,
              //             ),
              //           ),
              //           MyText(
              //             paddingLeft: 8,
              //             text: '194 / 31 days',
              //             size: 14,
              //             color: kGreyColor,
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 12,
              //       ),
              //       Row(
              //         children: [
              //           Image.asset(
              //             Assets.imagesDarkGreen,
              //             height: 16,
              //           ),
              //           Expanded(
              //             child: MyText(
              //               paddingLeft: 8,
              //               text: 'Over 8h',
              //               size: 14,
              //               color: kGreyColor,
              //             ),
              //           ),
              //           MyText(
              //             paddingLeft: 8,
              //             text: '83 / 31 days',
              //             size: 14,
              //             color: kGreyColor,
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 12,
              //       ),
              //       Row(
              //         children: [
              //           Image.asset(
              //             Assets.imagesNoRecord,
              //             height: 16,
              //           ),
              //           Expanded(
              //             child: MyText(
              //               paddingLeft: 8,
              //               text: 'No record',
              //               size: 14,
              //               color: kGreyColor,
              //             ),
              //           ),
              //           MyText(
              //             paddingLeft: 8,
              //             text: '-311 / 31 days',
              //             size: 14,
              //             color: kGreyColor,
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Moods by Sleep',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              _MoodBySleep()
            ],
          ),
        ),
      ],
    );
  }
}

// class _MoodFlowChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 239,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 10,
//           minimum: 0,
//           interval: 2,
//           isVisible: false,
//           plotOffset: 10.0,
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(),
//       ),
//     );
//   }

//   dynamic graphData() {
//     final List<_DataModel> _dataSource = [
//       _DataModel(
//         '8/1',
//         3,
//       ),
//       _DataModel(
//         '8/6',
//         4,
//       ),
//       _DataModel(
//         '8/11',
//         6,
//       ),
//       _DataModel(
//         '8/16',
//         5,
//       ),
//       _DataModel(
//         '8/21',
//         7,
//       ),
//       _DataModel(
//         '8/26',
//         6,
//       ),
//       _DataModel(
//         '8/31',
//         8,
//       ),
//     ];
//     return [
//       LineSeries<_DataModel, dynamic>(
//         dataSource: _dataSource,
//         xValueMapper: (_DataModel data, _) => data.xValueMapper,
//         yValueMapper: (_DataModel data, _) => data.yValueMapper,
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         // gradient: LinearGradient(
//         //   begin: Alignment.topCenter,
//         //   end: Alignment.bottomCenter,
//         //   stops: [
//         //     0.1,
//         //     0.9,
//         //   ],
//         //   colors: [
//         //     kSecondaryColor,
//         //     kSecondaryColor.withOpacity(0.33),
//         //   ],
//         // ),
//         color: kSecondaryColor,
//         width: 2,
//         markerSettings: MarkerSettings(
//           isVisible: true,
//         ),
//         // spacing: 0,
//         // borderRadius: BorderRadius.zero,
//       ),
//     ];
//   }
// }

// ------ My 1st Code --------

// class _MoodFlowChart extends StatelessWidget {
//   final List<DateWiseStressStats>? stats;

//   _MoodFlowChart({this.stats});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 239,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 10,
//           minimum: 0,
//           interval: 2,
//           isVisible: false,
//           plotOffset: 10.0,
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(stats),
//       ),
//     );
//   }

//   List<LineSeries<DateWiseStressStats, String>> graphData(
//       List<DateWiseStressStats>? stats) {
//     return [
//       LineSeries<DateWiseStressStats, String>(
//         dataSource: stats,
//         xValueMapper: (DateWiseStressStats data, _) => data.date ?? '',
//         yValueMapper: (DateWiseStressStats data, _) => data.stressLevel ?? 0,
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         color: kSecondaryColor,
//         width: 2,
//         markerSettings: MarkerSettings(
//           isVisible: true,
//         ),
//       ),
//     ];
//   }
// }
class _MoodFlowChart extends StatelessWidget {
  final List<MoodFlowModel>? stats;

  _MoodFlowChart({this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 239,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        margin: EdgeInsets.zero,
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          name: 'yAxis',
          maximum: 4, // Stress level max at +4
          minimum: -4, // Stress level min at -4
          interval: 1,
          isVisible: true,
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(
            width: 1,
            color: kBorderColor,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          opposedPosition: false,
          labelStyle: TextStyle(
            color: kGreyColor,
            fontSize: 12.0,
            fontFamily: AppFonts.URBANIST,
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: stats != null ? stats!.length.toDouble() : 6,
          minimum: 0,
          interval: 1,
          plotOffset: 5,
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          labelStyle: TextStyle(
            color: kGreyColor,
            fontSize: 12.0,
            fontFamily: AppFonts.URBANIST,
          ),
          labelRotation: 0, // Keep labels straight
          axisLabelFormatter: (args) {
            // If the label is '7', don't display it
            if (args.text == '7') {
              return ChartAxisLabel(
                  '', TextStyle()); // Return an empty label for '7'
            }
            return ChartAxisLabel(args.text,
                args.textStyle); // Otherwise, return the original label
          },
        ),
        series: graphData(stats),
      ),
    );
  }

  List<LineSeries<MoodFlowModel, String>> graphData(
      List<MoodFlowModel>? stats) {
    return [
      LineSeries<MoodFlowModel, String>(
        dataSource: stats,
        xValueMapper: (MoodFlowModel data, _) {
          // Format the date as "day/month"
          if (data.date != null) {
            return DateFormat('d/M').format(DateTime.parse(data.date!));
          }
          return '';
        },
        yValueMapper: (MoodFlowModel data, _) => data.mood ?? 0,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kSecondaryColor,
        width: 2,
        markerSettings: MarkerSettings(
          isVisible: true,
        ),
      ),
    ];
  }
}

// class _MoodBySleep extends StatelessWidget {
//   var ctrl = Get.find<ClientHomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 10,
//           minimum: 0,
//           interval: 2,
//           isVisible: false,
//           plotOffset: 10.0,
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(),
//       ),
//     );
//   }

//   dynamic graphData() {
//     final List<_DataModel> _dataSource = [
//       _DataModel(
//         '<5h',
//         3,
//       ),
//       _DataModel(
//         '<6h',
//         4,
//       ),
//       _DataModel(
//         '<7h',
//         6,
//       ),
//       _DataModel(
//         '<8h',
//         5,
//       ),
//       _DataModel(
//         '<9h',
//         7,
//       ),
//       _DataModel(
//         '<10h',
//         6,
//       ),
//       _DataModel(
//         '<11h',
//         8,
//       ),
//     ];
//     return [
//       ColumnSeries<_DataModel, dynamic>(
//         dataSource: _dataSource,
//         xValueMapper: (_DataModel data, _) => data.xValueMapper,
//         yValueMapper: (_DataModel data, _) => data.yValueMapper,
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [
//             0.1,
//             0.9,
//           ],
//           colors: [
//             kSecondaryColor,
//             kSecondaryColor.withOpacity(0.33),
//           ],
//         ),
//         color: kSecondaryColor,
//         width: 0.7,
//         spacing: 0,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(4),
//         ),
//       ),
//     ];
//   }
// }

class _MoodBySleep extends StatelessWidget {
  final ctrl = Get.find<ClientHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 200,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          margin: EdgeInsets.zero,
          borderWidth: 0,
          borderColor: Colors.transparent,
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          primaryYAxis: NumericAxis(
            name: 'yAxis',
            maximum: 4, // Mood range from -4 to +4
            minimum: -4,
            interval: 1, // Display each mood value
            plotOffset: 10.0,
            majorGridLines: MajorGridLines(width: 1, color: kBorderColor),
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(
              color: kGreyColor,
              fontSize: 12.0,
              fontFamily: AppFonts.URBANIST,
            ),
          ),
          primaryXAxis: CategoryAxis(
            name: 'xAxis',
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            labelStyle: TextStyle(
              color: kGreyColor,
              fontSize: 12.0,
              fontFamily: AppFonts.URBANIST,
            ),
          ),
          series: graphData(ctrl.moodBySleepStats),
        ),
      );
    });
  }

  /// Generate graph data based on `moodBySleepStats` and ensure all 7 categories are displayed
  List<ColumnSeries<_DataModel, String>> graphData(List<MoodSleepStats> stats) {
    // Define 7 sleep duration buckets
    final List<String> sleepBuckets = [
      "<4h",
      "<5h",
      "<6h",
      "<7h",
      "<8h",
      "<9h",
      "<10h"
    ];

    // Initialize map with all buckets and no data
    final Map<String, List<MoodSleepStats>> groupedData = {
      for (var bucket in sleepBuckets) bucket: []
    };

    // Populate the map with actual data
    for (var stat in stats) {
      String sleepLabel = _getSleepDurationLabel(stat.sleepDuration);
      groupedData[sleepLabel]?.add(stat);
    }

    // Create a data source ensuring all 7 buckets exist
    final List<_DataModel> _dataSource = sleepBuckets.map((bucket) {
      final List<MoodSleepStats> moods = groupedData[bucket]!;
      double avgMood = moods.isNotEmpty
          ? moods.map((e) => e.mood).reduce((a, b) => a + b) / moods.length
          : 0;

      return _DataModel(bucket, moods.isEmpty ? null : avgMood);
    }).toList();

    return [
      ColumnSeries<_DataModel, String>(
        dataSource: _dataSource,
        xValueMapper: (_DataModel data, _) => data.xValue,
        yValueMapper: (_DataModel data, _) => data.yValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
          colors: [kSecondaryColor, kSecondaryColor.withOpacity(0.33)],
        ),
        color: kSecondaryColor,
        width: 0.7,
        spacing: 0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
    ];
  }

  /// Function to determine sleep duration bucket
  String _getSleepDurationLabel(int sleepDuration) {
    if (sleepDuration < 4) return "<4h";
    if (sleepDuration < 5) return "<5h";
    if (sleepDuration < 6) return "<6h";
    if (sleepDuration < 7) return "<7h";
    if (sleepDuration < 8) return "<8h";
    if (sleepDuration < 9) return "<9h";
    return "<10h";
  }
}

/// Data model for chart representation
class _DataModel {
  _DataModel(this.xValue, this.yValue);
  final String xValue; // Sleep duration bucket
  final double? yValue; // Average Mood (null if no data)
}

// class _DataModel {
//   _DataModel(
//     this.xValueMapper,
//     this.yValueMapper,
//   );

//   String? xValueMapper;
//   int? yValueMapper;
// }

class SleepAnalysis extends StatelessWidget {
  final ctrl = Get.find<ClientHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 200,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          margin: EdgeInsets.zero,
          borderWidth: 0,
          borderColor: Colors.transparent,
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          primaryYAxis: NumericAxis(
            name: 'yAxis',
            maximum: 24, // 24-hour format
            minimum: 0,
            interval: 4,
            isVisible: true,
            axisLabelFormatter: (AxisLabelRenderDetails details) {
              return ChartAxisLabel('${details.value.toInt()}h',
                  TextStyle(color: Colors.grey, fontSize: 12.0));
            },
            majorGridLines:
                MajorGridLines(width: 1, color: Colors.grey.shade300),
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          primaryXAxis: CategoryAxis(
            name: 'xAxis',
            labelStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0),
          ),
          series: graphData(ctrl.sleepStats),
        ),
      );
    });
  }

  List<ColumnSeries<_ChartSampleData, String>> graphData(
      List<SleepData> sleepStats) {
    if (sleepStats.isEmpty) return [];

    final List<_ChartSampleData> _dataSource = sleepStats.map((data) {
      return _ChartSampleData(
        x: _formatDateByWeek(data.date ?? ""), // Group dates by weeks
        y: data.sleepTime?.toDouble() ?? 0,
      );
    }).toList();

    return [
      ColumnSeries<_ChartSampleData, String>(
        dataSource: _dataSource,
        xValueMapper: (_ChartSampleData data, _) => data.x,
        yValueMapper: (_ChartSampleData data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    ];
  }

  /// Formats date to group by week and show dates accordingly.
  String _formatDateByWeek(String date) {
    if (date.isEmpty) return "";
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day}';
  }
}

class _ChartSampleData {
  final String x;
  final double y;

  _ChartSampleData({required this.x, required this.y});
}

class Month {
  final String name;
  final int number;

  Month({required this.name, required this.number});

  // Factory constructor to create a Month object from a map
  factory Month.fromMap(Map<String, dynamic> map) {
    return Month(
      name: map['name'],
      number: map['number'],
    );
  }

  // Convert a Month object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
    };
  }
}

/*
----------------------------
 Monthly Stats
----------------------------
 */

class _Monthly extends StatefulWidget {
  _Monthly({super.key});

  @override
  State<_Monthly> createState() => __MonthlyState();
}

class __MonthlyState extends State<_Monthly> {
  var ctrl = Get.find<ClientHomeController>();

  @override
  Widget build(BuildContext context) {
    // ctrl.getSleepStats(
    //     haveMonthly: true, userID: UserService.instance.userModel.value.id);

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 120),
      physics: BouncingScrollPhysics(),
      children: [
        // ----- Week Selector Button ----------

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: List.generate(
        //     4,
        //     (index) => GestureDetector(
        //       onTap: () async {
        //         ctrl.weekFrontUpdate.value = index;
        //         ctrl.weekIndex.value = index + 1;
        //         log("${ctrl.weekIndex.value}");

        //         showLoadingDialog();
        //         await ctrl.allStats(
        //             userID: UserService.instance.userModel.value.id);
        //         hideLoadingDialog();
        //         setState(() {});
        //       },
        //       child: Obx(
        //         () => Container(
        //           height: 40,
        //           width: 70,
        //           decoration: BoxDecoration(
        //               color: kWhiteColor,
        //               border: Border.all(
        //                   color: (ctrl.weekFrontUpdate == index)
        //                       ? kSecondaryColor
        //                       : kWhiteColor),
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Center(child: MyText(text: '${weeks[index]}')),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Month',
            ),
            Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Center(
                child: Obx(() => DropdownButton<MonthModel>(
                      value: ctrl.selectedMonthModel.value,
                      onChanged: (MonthModel? newValue) {
                        if (newValue != null) {
                          ctrl.selectedMonthModel.value = newValue;

                          // widget.onMonthSelected(newValue);
                        }
                      },
                      items: ctrl.months.map<DropdownMenuItem<MonthModel>>(
                          (MonthModel month) {
                        return DropdownMenuItem<MonthModel>(
                          value: month,
                          child: MyText(
                            text: month.name,
                            size: 13,
                          ),
                        );
                      }).toList(),
                      underline: SizedBox.shrink(),
                    )),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
// ----------- Mode Flow Card ------------

        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Mood Flow',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 17),
                      child: Transform(
                        alignment: Alignment.center, // Flip around the center
                        transform: Matrix4.rotationX(
                            3.14159), // Flip vertically (bottom to top)
                        child: Image.asset(
                          Assets.imagesColorDots,
                          height: 210,
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),

                  // ------- Model Flow Chat ------

                  Expanded(
                    child: Obx(
                      () => (ctrl.moodFlowStatsMonthly != null &&
                              ctrl.moodFlowStatsMonthly!.isNotEmpty)
                          ? _MoodFlowChartMonthly(
                              // stats: ctrl.moodFlowStats,
                              stats: ctrl.moodFlowStatsMonthly,
                            )
                          : _MoodFlowChartMonthly(
                              // stats: ctrl.moodFlowStats,
                              stats: ctrl.moodFlowStatsMonthly,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              (ctrl.moodFlowStatsMonthly != null)
                  ? SizedBox.shrink()
                  : RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: kTertiaryColor,
                          fontFamily: AppFonts.URBANIST,
                        ),
                        children: [
                          TextSpan(
                            text: 'Mood Patterns: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'No data available. ',
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),

        // ---------- Mood Bar Percentage Monthly----------

        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            children: [
              MyText(
                text: 'Mood Bar',
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
                    // Extract stress level for the current item
                    String stressLevel = stressItems[index].level.toString();

                    // Safely get the percentage for the current stress level
                    String? percentage = ctrl.emotionPercentageStatsMonthly
                        ?.firstWhere(
                          (item) => item.stressLevel == stressLevel,
                          orElse: () => StressLevelPercentage(
                              stressLevel: null, percentage: null),
                        )
                        .percentage;

                    // log('Stress Level: $stressLevel, Percentage: $percentage');

                    return Column(
                      children: [
                        // Display iconA if percentage exists, otherwise iconB
                        Image.asset(
                          percentage != null
                              ? stressItems[index].selectedIcon
                              : stressItems[index].unselectedIcon,
                          height: 44,
                        ),
                        const SizedBox(height: 8),

                        // Progress bar using Container with text
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background bar
                            Container(
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                color: (percentage != null)
                                    ? kSecondaryColor
                                    : kGreyColor3,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),

                            MyText(
                              text: percentage ?? '0%',
                              size: 12,
                              color:
                                  percentage != null ? kWhiteColor : kGreyColor,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        SizedBox(
          height: 12,
        ),

        //  ---- Sleep Analysis Montly ---

        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Sleep Analysis',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Bedtime',
                            size: 12,
                            color: kGreyColor,
                          ),

                          // ------ Average Bed Time -------
                          MyText(
                            paddingTop: 4,
                            text:
                                '${ctrl.sleepAnalysisMonthModel.value?.averageBedtime}',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Wake Up',
                            size: 12,
                            color: kGreyColor,
                          ),
                          MyText(
                            paddingTop: 4,
                            text:
                                '${ctrl.sleepAnalysisMonthModel.value?.averageWakeupTime}',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              // --------- Sleep Duration Graph Montly ------------

              SleepAnalysisMonthlyWidget(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: AppStyling.CUSTOM_CARD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: 'Moods by Sleep',
                size: 16,
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 16,
              ),
              _MoodBySleep()
            ],
          ),
        ),
      ],
    );
  }
}

/*
Montly Graph Widgets 
 */

class _MoodFlowChartMonthly extends StatelessWidget {
  final List<MoodFlowModel>? stats;

  _MoodFlowChartMonthly({this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 239,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        margin: EdgeInsets.zero,
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          name: 'yAxis',
          maximum: 4, // Stress level max at +4
          minimum: -4, // Stress level min at -4
          interval: 1,
          isVisible: true,
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(
            width: 1,
            color: kBorderColor,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          opposedPosition: false,
          labelStyle: TextStyle(
            color: kGreyColor,
            fontSize: 12.0,
            fontFamily: AppFonts.URBANIST,
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: 30,
          minimum: 1,
          interval: 1,
          plotOffset: 5,
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          labelStyle: TextStyle(
            color: kGreyColor,
            fontSize: 12.0,
            fontFamily: AppFonts.URBANIST,
          ),
          labelRotation: 0, // Keep labels straight
        ),
        series: graphData(stats),
      ),
    );
  }

  List<LineSeries<MoodFlowModel, String>> graphData(
      List<MoodFlowModel>? stats) {
    return [
      LineSeries<MoodFlowModel, String>(
        dataSource: stats,
        xValueMapper: (MoodFlowModel data, _) {
          // Format the date as "day" only for 30 days view
          if (data.date != null) {
            return DateFormat('d').format(DateTime.parse(data.date!));
          }
          return '';
        },
        yValueMapper: (MoodFlowModel data, _) => data.mood ?? 0,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kSecondaryColor,
        width: 2,
        markerSettings: MarkerSettings(
          isVisible: true,
        ),
      ),
    ];
  }
}

class SleepAnalysisMonthlyWidget extends StatelessWidget {
  final ctrl = Get.find<ClientHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 200,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          margin: EdgeInsets.zero,
          borderWidth: 0,
          borderColor: Colors.transparent,
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          primaryYAxis: NumericAxis(
            name: 'yAxis',
            maximum: 24, // 24-hour format
            minimum: 0,
            interval: 4,
            isVisible: true,
            axisLabelFormatter: (AxisLabelRenderDetails details) {
              return ChartAxisLabel('${details.value.toInt()}h',
                  TextStyle(color: Colors.grey, fontSize: 12.0));
            },
            majorGridLines:
                MajorGridLines(width: 1, color: Colors.grey.shade300),
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          primaryXAxis: CategoryAxis(
            name: 'xAxis',
            maximum: 30,
            minimum: 1,
            interval: 1,
            labelStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0),
          ),
          series: graphData(ctrl.sleepStatsMontly),
        ),
      );
    });
  }

  List<ColumnSeries<_ChartSampleData, String>> graphData(
      List<SleepData> sleepStats) {
    if (sleepStats.isEmpty) return [];

    final List<_ChartSampleData> _dataSource = sleepStats.map((data) {
      return _ChartSampleData(
        x: _formatDateByMonth(data.date ?? ""), // Group dates by month
        y: data.sleepTime?.toDouble() ?? 0,
      );
    }).toList();

    return [
      ColumnSeries<_ChartSampleData, String>(
        dataSource: _dataSource,
        xValueMapper: (_ChartSampleData data, _) => data.x,
        yValueMapper: (_ChartSampleData data, _) => data.y,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        pointColorMapper: (_, __) => LinearGradient(
          begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          colors: [kSecondaryColor, Colors.orange],
        ).colors.first,
        borderRadius: BorderRadius.circular(10),
      ),
    ];
  }

  /// Formats date to group by month and show dates accordingly.
  String _formatDateByMonth(String date) {
    if (date.isEmpty) return "";
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day}';
  }
}






//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// --------------- Report Front-End Screen Commented Below --------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mood_prints/constants/app_colors.dart';
// import 'package:mood_prints/constants/app_fonts.dart';
// import 'package:mood_prints/constants/app_images.dart';
// import 'package:mood_prints/constants/app_sizes.dart';
// import 'package:mood_prints/constants/app_styling.dart';
// import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
// import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
// import 'package:mood_prints/view/widget/my_button_widget.dart';
// import 'package:mood_prints/view/widget/my_text_widget.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class Report extends StatelessWidget {
//   Report({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> _items = [
//       'Monthly',
//       'Annual',
//     ];
//     final List<Widget> _tabBarView = [
//       _Monthly(),
//       Container(),
//     ];
//     return DefaultTabController(
//       length: _items.length,
//       initialIndex: 0,
//       child: Scaffold(
//         backgroundColor: kPrimaryColor,
//         appBar: simpleAppBar(
//           title: 'Kazumi Report',
//           centerTitle: false,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TabBar(
//               labelColor: kSecondaryColor,
//               unselectedLabelColor: kGreyColor,
//               indicatorColor: kSecondaryColor,
//               automaticIndicatorColorAdjustment: false,
//               indicatorWeight: 2,
//               labelStyle: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: AppFonts.URBANIST,
//               ),
//               unselectedLabelStyle: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: AppFonts.URBANIST,
//               ),
//               tabs: _items.map(
//                 (e) {
//                   return Tab(
//                     text: e,
//                   );
//                 },
//               ).toList(),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: _tabBarView,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ExportData extends StatelessWidget {
//   const _ExportData({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: Container(
//             margin: AppSizes.DEFAULT,
//             padding: AppSizes.DEFAULT,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: kPrimaryColor,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           MyText(
//                             text: 'Export Data',
//                             size: 16,
//                             weight: FontWeight.w600,
//                           ),
//                           MyText(
//                             paddingTop: 6,
//                             text: 'Choose which stats info they can view?',
//                             size: 13,
//                             color: kGreyColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: Icon(
//                         Icons.close,
//                         color: kGreyColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   height: 1,
//                   color: kBorderColor,
//                   margin: EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 ...List.generate(
//                   5,
//                   (index) {
//                     final List<String> _items = [
//                       'Mood Flow',
//                       'Mood Bar',
//                       'Emotion',
//                       'Sleep Analysis',
//                       'Moods by Sleep',
//                     ];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Row(
//                         children: [
//                           CustomCheckBox(
//                             isActive: index == 0,
//                             onTap: () {},
//                           ),
//                           Expanded(
//                             child: MyText(
//                               text: _items[index],
//                               paddingLeft: 10,
//                               size: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 MyButton(
//                   buttonText: 'Export as PDF',
//                   onTap: () {},
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _Monthly extends StatelessWidget {
//   const _Monthly({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       padding: EdgeInsets.fromLTRB(20, 16, 20, 120),
//       physics: BouncingScrollPhysics(),
//       children: [
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: AppStyling.CUSTOM_CARD,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               MyText(
//                 text: 'Mood Flow',
//                 size: 16,
//                 weight: FontWeight.w600,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   Image.asset(
//                     Assets.imagesColorDots,
//                     height: 236,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: _MoodFlowChart(),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: kTertiaryColor,
//                     fontFamily: AppFonts.URBANIST,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: 'Mood Patterns: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'No data available. ',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 12,
//         ),
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: AppStyling.CUSTOM_CARD,
//           child: Column(
//             children: [
//               MyText(
//                 text: 'Mood Bar',
//                 size: 16,
//                 paddingBottom: 20,
//                 weight: FontWeight.w600,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: List.generate(
//                   9,
//                   (index) {
//                     final List<String> _items = [
//                       Assets.imagesExtremeCrying,
//                       Assets.imagesLittleCrying,
//                       Assets.imagesSad,
//                       Assets.imagesSad1,
//                       Assets.imagesLittleSad,
//                       Assets.imagesHappy,
//                       Assets.imagesSmile,
//                       Assets.imagesLittleSmiling,
//                       Assets.imagesLaughing,
//                     ];
//                     return Column(
//                       children: [
//                         Image.asset(
//                           _items[index],
//                           height: 44,
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 index == 0 ? kSecondaryColor : kOffWhiteColor,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: MyText(
//                             text: '4%',
//                             size: 12,
//                             color: index == 0 ? kWhiteColor : kGreyColor,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 12,
//         ),
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: AppStyling.CUSTOM_CARD,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   MyText(
//                     text: 'Emotions',
//                     size: 16,
//                     weight: FontWeight.w600,
//                     textAlign: TextAlign.center,
//                   ),
//                   Image.asset(
//                     Assets.imagesArrowNext,
//                     height: 24,
//                     color: kGreyColor,
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 physics: BouncingScrollPhysics(),
//                 itemCount: 3,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   mainAxisExtent: 150,
//                 ),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     margin: EdgeInsets.symmetric(
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: kWhiteColor,
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 4),
//                           blurRadius: 10,
//                           color: kTertiaryColor.withOpacity(0.1),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         MyText(
//                           text: '${index + 1}',
//                           size: 12,
//                           weight: FontWeight.w600,
//                         ),
//                         Container(
//                           height: 44,
//                           width: 44,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: kLightGreyColor,
//                           ),
//                           child: Center(
//                             child: MyText(
//                               text: '😁',
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                         MyText(
//                           paddingTop: 8,
//                           paddingBottom: 6,
//                           text: 'Proud',
//                           size: 12,
//                           textAlign: TextAlign.center,
//                           weight: FontWeight.w600,
//                         ),
//                         MyText(
//                           textAlign: TextAlign.center,
//                           text: 'x1',
//                           size: 12,
//                           color: kGreyColor,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: kTertiaryColor,
//                     fontFamily: AppFonts.URBANIST,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: 'You recorded',
//                     ),
//                     TextSpan(
//                       text: ' Excited ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: kSecondaryColor,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'the most.',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 12,
//         ),
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: AppStyling.CUSTOM_CARD,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               MyText(
//                 text: 'Sleep Analysis',
//                 size: 16,
//                 weight: FontWeight.w600,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           width: 1.0,
//                           color: kBorderColor,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           MyText(
//                             text: 'Bedtime',
//                             size: 12,
//                             color: kGreyColor,
//                           ),
//                           MyText(
//                             paddingTop: 4,
//                             text: '01:51 AM',
//                             size: 16,
//                             weight: FontWeight.w600,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           width: 1.0,
//                           color: kBorderColor,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           MyText(
//                             text: 'Wake Up',
//                             size: 12,
//                             color: kGreyColor,
//                           ),
//                           MyText(
//                             paddingTop: 4,
//                             text: '09:48 AM',
//                             size: 16,
//                             weight: FontWeight.w600,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               _SleepAnalysis(),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     width: 1.0,
//                     color: kBorderColor,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           Assets.imagesOrange,
//                           height: 16,
//                         ),
//                         Expanded(
//                           child: MyText(
//                             paddingLeft: 8,
//                             text: 'Less than 6h',
//                             size: 14,
//                             color: kGreyColor,
//                           ),
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: '65 / 31 days',
//                           size: 14,
//                           color: kGreyColor,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           Assets.imagesLightGreen,
//                           height: 16,
//                         ),
//                         Expanded(
//                           child: MyText(
//                             paddingLeft: 8,
//                             text: '6-8h',
//                             size: 14,
//                             color: kGreyColor,
//                           ),
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: '194 / 31 days',
//                           size: 14,
//                           color: kGreyColor,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           Assets.imagesDarkGreen,
//                           height: 16,
//                         ),
//                         Expanded(
//                           child: MyText(
//                             paddingLeft: 8,
//                             text: 'Over 8h',
//                             size: 14,
//                             color: kGreyColor,
//                           ),
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: '83 / 31 days',
//                           size: 14,
//                           color: kGreyColor,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           Assets.imagesNoRecord,
//                           height: 16,
//                         ),
//                         Expanded(
//                           child: MyText(
//                             paddingLeft: 8,
//                             text: 'No record',
//                             size: 14,
//                             color: kGreyColor,
//                           ),
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: '-311 / 31 days',
//                           size: 14,
//                           color: kGreyColor,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 12,
//         ),
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: AppStyling.CUSTOM_CARD,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               MyText(
//                 text: 'Moods by Sleep',
//                 size: 16,
//                 weight: FontWeight.w600,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               _MoodBySleep()
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _MoodFlowChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 239,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 10,
//           minimum: 0,
//           interval: 2,
//           isVisible: false,
//           plotOffset: 10.0,
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(),
//       ),
//     );
//   }

//   dynamic graphData() {
//     final List<_DataModel> _dataSource = [
//       _DataModel(
//         '8/1',
//         3,
//       ),
//       _DataModel(
//         '8/6',
//         4,
//       ),
//       _DataModel(
//         '8/11',
//         6,
//       ),
//       _DataModel(
//         '8/16',
//         5,
//       ),
//       _DataModel(
//         '8/21',
//         7,
//       ),
//       _DataModel(
//         '8/26',
//         6,
//       ),
//       _DataModel(
//         '8/31',
//         8,
//       ),
//     ];
//     return [
//       LineSeries<_DataModel, dynamic>(
//         dataSource: _dataSource,
//         xValueMapper: (_DataModel data, _) => data.xValueMapper,
//         yValueMapper: (_DataModel data, _) => data.yValueMapper,
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         // gradient: LinearGradient(
//         //   begin: Alignment.topCenter,
//         //   end: Alignment.bottomCenter,
//         //   stops: [
//         //     0.1,
//         //     0.9,
//         //   ],
//         //   colors: [
//         //     kSecondaryColor,
//         //     kSecondaryColor.withOpacity(0.33),
//         //   ],
//         // ),
//         color: kSecondaryColor,
//         width: 2,
//         markerSettings: MarkerSettings(
//           isVisible: true,
//         ),
//         // spacing: 0,
//         // borderRadius: BorderRadius.zero,
//       ),
//     ];
//   }
// }

// class _MoodBySleep extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 10,
//           minimum: 0,
//           interval: 2,
//           isVisible: false,
//           plotOffset: 10.0,
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(),
//       ),
//     );
//   }

//   dynamic graphData() {
//     final List<_DataModel> _dataSource = [
//       _DataModel(
//         '<5h',
//         3,
//       ),
//       _DataModel(
//         '<6h',
//         4,
//       ),
//       _DataModel(
//         '<7h',
//         6,
//       ),
//       _DataModel(
//         '<8h',
//         5,
//       ),
//       _DataModel(
//         '<9h',
//         7,
//       ),
//       _DataModel(
//         '<10h',
//         6,
//       ),
//       _DataModel(
//         '<11h',
//         8,
//       ),
//     ];
//     return [
//       ColumnSeries<_DataModel, dynamic>(
//         dataSource: _dataSource,
//         xValueMapper: (_DataModel data, _) => data.xValueMapper,
//         yValueMapper: (_DataModel data, _) => data.yValueMapper,
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [
//             0.1,
//             0.9,
//           ],
//           colors: [
//             kSecondaryColor,
//             kSecondaryColor.withOpacity(0.33),
//           ],
//         ),
//         color: kSecondaryColor,
//         width: 0.7,
//         spacing: 0,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(4),
//         ),
//       ),
//     ];
//   }
// }

// class _SleepAnalysis extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: SfCartesianChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//         ),
//         margin: EdgeInsets.zero,
//         borderWidth: 0,
//         borderColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         enableAxisAnimation: true,
//         primaryYAxis: NumericAxis(
//           name: 'yAxis',
//           maximum: 5000,
//           minimum: 0,
//           interval: 1000,
//           isVisible: true,
//           plotOffset: 10.0,
//           axisLabelFormatter: (AxisLabelRenderDetails details) {
//             return ChartAxisLabel(
//               (details.value ~/ 1000).toString() + 'P',
//               null,
//             );
//           },
//           majorGridLines: MajorGridLines(
//             width: 1,
//             color: kBorderColor,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           opposedPosition: false,
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         primaryXAxis: CategoryAxis(
//           name: 'xAxis',
//           maximum: 6,
//           minimum: 0,
//           interval: 1,
//           plotOffset: 5,
//           majorGridLines: MajorGridLines(
//             width: 0,
//           ),
//           axisLine: AxisLine(
//             width: 0,
//           ),
//           majorTickLines: MajorTickLines(
//             width: 0,
//           ),
//           labelStyle: TextStyle(
//             color: kGreyColor,
//             fontSize: 12.0,
//             fontFamily: AppFonts.URBANIST,
//           ),
//         ),
//         series: graphData(),
//         onDataLabelRender: (DataLabelRenderArgs dataLabelArgs) {
//           if (dataLabelArgs.pointIndex == 0) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 1) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 2) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 3) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 4) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 5) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 6) {
//             dataLabelArgs.text = '';
//           } else if (dataLabelArgs.pointIndex == 7) {
//             dataLabelArgs.text = '';
//           }
//         },
//       ),
//     );
//   }

//   dynamic graphData() {
//     final List<_ChartSampleData> _dataSource = [
//       _ChartSampleData(
//         x: '8/1',
//         y: 4700,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/6',
//         y: -1100,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/11',
//         y: -700,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/16',
//         y: 1200,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/21',
//         intermediateSumPredicate: true,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/26',
//         y: -400,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//       _ChartSampleData(
//         x: '8/31',
//         y: -800,
//         intermediateSumPredicate: false,
//         totalSumPredicate: false,
//       ),
//     ];
//     return [
//       WaterfallSeries<_ChartSampleData, dynamic>(
//         dataSource: _dataSource,
//         xValueMapper: (_ChartSampleData data, _) => data.x,
//         yValueMapper: (_ChartSampleData data, _) => data.y,
//         intermediateSumPredicate: (_ChartSampleData sales, _) =>
//             sales.intermediateSumPredicate,
//         totalSumPredicate: (_ChartSampleData sales, _) =>
//             sales.totalSumPredicate,
//         dataLabelSettings: const DataLabelSettings(
//           isVisible: true,
//           labelAlignment: ChartDataLabelAlignment.middle,
//         ),
//         xAxisName: 'xAxis',
//         yAxisName: 'yAxis',
//         width: 0.7,
//         spacing: 0,
//         borderRadius: BorderRadius.circular(50),
//         negativePointsColor: Color(0xffF4A460),
//         intermediateSumColor: Color(0xff77ACA2),
//         totalSumColor: Color(0xff468189),
//       ),
//     ];
//   }
// }

// class _DataModel {
//   _DataModel(
//     this.xValueMapper,
//     this.yValueMapper,
//   );

//   String? xValueMapper;
//   int? yValueMapper;
// }

// class _ChartSampleData {
//   _ChartSampleData({
//     this.x,
//     this.y,
//     this.intermediateSumPredicate,
//     this.totalSumPredicate,
//   });

//   final String? x;
//   final num? y;
//   final bool? intermediateSumPredicate;
//   final bool? totalSumPredicate;
// }



