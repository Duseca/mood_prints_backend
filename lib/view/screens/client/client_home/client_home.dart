import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ClientHome extends StatelessWidget {
  const ClientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Home',
        centerTitle: false,
        haveLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          _Calendar(),
        ],
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
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
          focusedDay: DateTime.now(),
          rowHeight: 40,
          daysOfWeekHeight: 50,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) {
              return DateFormat.E(locale).format(date).toUpperCase();
            },
            weekdayStyle: _DEFAULT_TEXT_STYLE.copyWith(
              color: kSecondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {},
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
