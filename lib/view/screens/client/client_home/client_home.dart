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
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/screens/client/edit_mode_manager/edit_mode_manager.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ClientHome extends StatefulWidget {
  ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final eventDates = [
    DateTime.now(),
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
  ];

  final homeCtrl = Get.find<ClientHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Home',
        centerTitle: false,
        haveLeading: false,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            // shrinkWrap: true,
            // padding: AppSizes.DEFAULT,
            // physics: BouncingScrollPhysics(),
            children: [
              //----- Calender -----

              Obx(
                () => _Calendar(
                  eventDates: (homeCtrl.allboardDates.isNotEmpty)
                      ? homeCtrl.allboardDates
                      : [],
                ),
              ),

              Obx(
                () => Column(
                  children:
                      List.generate(homeCtrl.allBoardsData.length, (headIndex) {
                    final model = homeCtrl.allBoardsData[headIndex];

                    // Loop for getting emotion icon

                    int? _iconIndex;
                    for (int i = 0; i < feelingItems.length; i++) {
                      if (model.stressLevel == feelingItems[i].stressLevel) {
                        _iconIndex = i;
                        break;
                      }
                    }
                    return DetailCard(
                      emotionWidget: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: (_iconIndex != null)
                              ? CommonImageView(
                                  height: 44,
                                  width: 44,
                                  imagePath: feelingItems[_iconIndex].iconA)
                              : CommonImageView(
                                  height: 44,
                                  width: 44,
                                  imagePath: feelingItems[0].iconA)),
                      imageList: (model.photos != null) ? model.photos! : [],
                      headIndex: headIndex,
                      note: model.note,
                      bedTime: model.sleep.dozeOffTime,
                      riseTime: model.sleep.wakeupTime,
                      dateTime: model.date,
                      onDeleteTap: () {
                        log('work');
                        log('Board ID: ${model.id}');
                        homeCtrl.deleteBoard(model.id);
                      },
                      onEditTap: () {
                        Get.to(() => EditModeManager(model: model));
                      },
                    );
                  }),
                ),
              ),

              SizedBox(
                height: 100,
              ),

              // MyButton(
              //   buttonText: 'Hit',
              //   onTap: () {
              //     homeCtrl.calledStats();
              //     // homeCtrl.getEmotionStats();
              //     // homeCtrl.getModeWeeklyStats();
              //     // homeCtrl.getSleepWeeklyStats();
              //     //homeCtrl.getSleepWeeklyStats();
              //     // homeCtrl.getModeWeeklyStats();
              //     // Get.find<ClientHomeController>().getAllBoard();
              //   },
              // ),
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}

// class _Calendar extends StatefulWidget {
//   final List<DateTime> eventDates;
//   const _Calendar({
//     Key? key,
//     required this.eventDates,
//   }) : super(key: key);

//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<_Calendar> {
//   @override
//   Widget build(BuildContext context) {
//     final _DEFAULT_TEXT_STYLE = TextStyle(
//       fontSize: 14,
//       color: kTertiaryColor,
//       fontWeight: FontWeight.w500,
//       fontFamily: AppFonts.URBANIST,
//     );

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TableCalendar(
//           headerStyle: _header(),
//           firstDay: DateTime.utc(2010, 10, 16),
//           lastDay: DateTime.utc(2030, 3, 14),
//           focusedDay: DateTime.now(),
//           rowHeight: 40,
//           daysOfWeekHeight: 50,
//           daysOfWeekStyle: DaysOfWeekStyle(
//             dowTextFormatter: (date, locale) {
//               return DateFormat.E(locale).format(date).toUpperCase();
//             },
//             weekdayStyle: _DEFAULT_TEXT_STYLE.copyWith(
//               color: kSecondaryColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           onDaySelected: (selectedDay, focusedDay) {},
//           calendarStyle: CalendarStyle(
//             tablePadding: EdgeInsets.zero,
//             defaultTextStyle: _DEFAULT_TEXT_STYLE,
//             selectedTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
//               color: kPrimaryColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//             todayTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
//               color: kPrimaryColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//             disabledTextStyle: _DEFAULT_TEXT_STYLE,
//             holidayTextStyle: _DEFAULT_TEXT_STYLE,
//             outsideTextStyle: _DEFAULT_TEXT_STYLE,
//             weekendTextStyle: _DEFAULT_TEXT_STYLE,
//             rangeEndTextStyle: _DEFAULT_TEXT_STYLE,
//             weekNumberTextStyle: _DEFAULT_TEXT_STYLE,
//             rangeStartTextStyle: _DEFAULT_TEXT_STYLE,
//             withinRangeTextStyle: _DEFAULT_TEXT_STYLE,
//             selectedDecoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: kSecondaryColor,
//             ),
//             cellMargin: EdgeInsets.zero,
//             todayDecoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: kSecondaryColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   HeaderStyle _header() {
//     return HeaderStyle(
//       headerPadding: EdgeInsets.all(8),
//       formatButtonVisible: false,
//       titleCentered: true,
//       titleTextStyle: TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.w600,
//         color: kTertiaryColor,
//       ),
//       titleTextFormatter: (date, locale) {
//         return DateFormat.yMMMMd(locale).format(date).toUpperCase();
//       },
//       leftChevronMargin: EdgeInsets.zero,
//       leftChevronPadding: EdgeInsets.zero,
//       leftChevronIcon: Container(
//         height: 32,
//         width: 32,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           color: kSecondaryColor,
//         ),
//         child: Icon(
//           Icons.arrow_back,
//           size: 18,
//           color: kPrimaryColor,
//         ),
//       ),
//       rightChevronMargin: EdgeInsets.zero,
//       rightChevronPadding: EdgeInsets.zero,
//       rightChevronIcon: Container(
//         height: 32,
//         width: 32,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           color: kSecondaryColor,
//         ),
//         child: Icon(
//           Icons.arrow_forward,
//           size: 18,
//           color: kPrimaryColor,
//         ),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: kWhiteColor,
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class DetailCard extends StatelessWidget {
  final List<String> imageList;
  final String? note;
  final int headIndex;
  final String bedTime;
  final String riseTime;
  final DateTime dateTime;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;
  final Widget emotionWidget;
  // final int stressLevel;

  DetailCard({
    this.note,
    required this.imageList,
    required this.headIndex,
    required this.bedTime,
    required this.riseTime,
    required this.dateTime,
    required this.onDeleteTap,
    required this.onEditTap,
    required this.emotionWidget,
    // required this.stressLevel,
  });

  List<String> icons = [
    // Assets.imagesShareIcon,
    Assets.imagesEditIcon,
    Assets.imagesBinIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                  2,
                  (index) => Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: InkWell(
                          child: CommonImageView(
                              imagePath: icons[index], height: 20),
                          onTap: (index == 1) ? onDeleteTap : onEditTap,
                        ),
                      ))),
          Container(
            height: 270,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16.0),
            decoration: AppStyling.CUSTOM_CARD,
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      child: emotionWidget,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: 10),
                    //   child: (feelingItems.contains(stressLevel))
                    //       ? CommonImageView(
                    //           height: 44,
                    //           width: 44,
                    //           imagePath: feelingItems[stressLevel].iconA)
                    //       : SizedBox.shrink(),
                    // ),
                    MyText(
                      text:
                          '${DateTimeService.instance.formatDateWithDay(dateTime)}',
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),

                //-------- Divider -------

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        color: kGreyColor3,
                        width: 0.5,
                      ),
                    )
                  ],
                ),

                //----- Second Content -------

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        paddingBottom: 8,
                        text: '$note',
                        size: 12,
                        weight: FontWeight.w400,
                      ),

                      // -------- Images ---------

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (imageList.isNotEmpty)
                            ? Row(
                                children: List.generate(
                                    imageList.length,
                                    (imgIndex) => Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CommonImageView(
                                              height: 150,
                                              width: 150,
                                              url: imageList[imgIndex],
                                              // fit: BoxFit.contain,
                                            ),
                                          ),
                                        )),
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                color: kHintColor.withOpacity(0.1),
                                child: Center(
                                  child: MyText(
                                    text: 'No Image Found',
                                    color: kHintColor.withOpacity(0.6),
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kGreyColor3)),
                        child: Row(
                          children: [
                            CommonImageView(
                              height: 14,
                              width: 14,
                              imagePath: Assets.imagesHalfMoon,
                            ),
                            MyText(
                              paddingLeft: 8,
                              text: '$riseTime',
                              size: 12,
                              weight: FontWeight.w400,
                            ),
                            MyText(
                              text: ' - ',
                              size: 12,
                              weight: FontWeight.w400,
                            ),
                            MyText(
                              text: '${bedTime}',
                              size: 12,
                              weight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  final List<DateTime> eventDates;

  const _Calendar({
    Key? key,
    required this.eventDates, // Accept data as a parameter
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final _DEFAULT_TEXT_STYLE = TextStyle(
      fontSize: 14,
      color: kTertiaryColor,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.URBANIST,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableCalendar(
          headerStyle: _header(),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            // Highlight the selected day
            return isSameDay(_selectedDay, day);
          },
          eventLoader: (day) {
            // Highlight event dates
            return widget.eventDates.contains(day) ? ['Event'] : [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // Update focused day
            });
          },
          calendarStyle: CalendarStyle(
            tablePadding: EdgeInsets.zero,
            defaultTextStyle: _DEFAULT_TEXT_STYLE,
            selectedTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
              color: kPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            todayTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
              color: kPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            disabledTextStyle: _DEFAULT_TEXT_STYLE,
            holidayTextStyle: _DEFAULT_TEXT_STYLE,
            outsideTextStyle: _DEFAULT_TEXT_STYLE,
            weekendTextStyle: _DEFAULT_TEXT_STYLE,
            rangeEndTextStyle: _DEFAULT_TEXT_STYLE,
            weekNumberTextStyle: _DEFAULT_TEXT_STYLE,
            rangeStartTextStyle: _DEFAULT_TEXT_STYLE,
            withinRangeTextStyle: _DEFAULT_TEXT_STYLE,
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSecondaryColor,
            ),
            cellMargin: EdgeInsets.zero,
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  HeaderStyle _header() {
    return HeaderStyle(
      headerPadding: EdgeInsets.all(8),
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: kTertiaryColor,
      ),
      titleTextFormatter: (date, locale) {
        return DateFormat.yMMMMd(locale).format(date).toUpperCase();
      },
      leftChevronMargin: EdgeInsets.zero,
      leftChevronPadding: EdgeInsets.zero,
      leftChevronIcon: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: kSecondaryColor,
        ),
        child: Icon(
          Icons.arrow_back,
          size: 18,
          color: kPrimaryColor,
        ),
      ),
      rightChevronMargin: EdgeInsets.zero,
      rightChevronPadding: EdgeInsets.zero,
      rightChevronIcon: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: kSecondaryColor,
        ),
        child: Icon(
          Icons.arrow_forward,
          size: 18,
          color: kPrimaryColor,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: kWhiteColor,
      ),
    );
  }
}
