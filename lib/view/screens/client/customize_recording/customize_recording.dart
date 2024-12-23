import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/screens/client/customize_recording/active_block.dart';
import 'package:mood_prints/view/screens/client/customize_recording/hidden_blocks.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';

class CustomizeRecording extends StatelessWidget {
  CustomizeRecording({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> _items = [
      'Active blocks',
      'Hidden blocks',
    ];
    final List<Widget> _tabBarView = [
      ActiveBlock(),
      HiddenBlocks(),
    ];
    return DefaultTabController(
      length: _items.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: simpleAppBar(
          title: 'Customize recording page',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: TabBar(
                labelColor: kSecondaryColor,
                unselectedLabelColor: kGreyColor,
                indicatorColor: kSecondaryColor,
                automaticIndicatorColorAdjustment: false,
                indicatorWeight: 2,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.URBANIST,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.URBANIST,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _items.map(
                  (e) {
                    return Tab(
                      text: e,
                    );
                  },
                ).toList(),
              ),
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
