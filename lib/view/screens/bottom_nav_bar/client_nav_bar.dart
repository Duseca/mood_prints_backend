import 'dart:io';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/chat/chat_head.dart';
import 'package:mood_prints/view/screens/client/client_home/client_home.dart';
import 'package:mood_prints/view/screens/client/client_profile/client_profile.dart';
import 'package:mood_prints/view/screens/client/client_stats/client_stats.dart';
import 'package:mood_prints/view/screens/client/customize_recording/mode_manager.dart';
import 'package:mood_prints/view/screens/privacy_policy/hippa_pdf_view.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class ClientNavBar extends StatefulWidget {
  @override
  _ClientNavBarState createState() => _ClientNavBarState();
}

class _ClientNavBarState extends State<ClientNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserService.instance.isTenDaysCompleted();
  }

  void _getCurrentIndex(int index) => setState(() {
        _currentIndex = index;
      });

  // void v() async {
  //   final pref = await SharedPreferences.getInstance();
  //   // log("Autherization Token Key: ${pref.getString('token')}");
  //   // log("id --->: ${pref.getString('id')}");
  // }

  final List<Widget> _screens = [
    ClientHome(),
    ClientStats(),
    ChatHead(),
    ClientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    // v();
    final List<Map<String, dynamic>> _items = [
      {
        'icon': Assets.imagesHome,
        'iconA': Assets.imagesHomeA,
        'label': 'Home',
      },
      {
        'icon': Assets.imagesStats,
        'iconA': Assets.imagesStatA,
        'label': 'Stats',
      },
      {
        'icon': Assets.imagesChat,
        'iconA': Assets.imagesChatA,
        'label': 'Chat',
      },
      {
        'icon': Assets.imagesProfile,
        'iconA': Assets.imagesProfileA,
        'label': 'Profile',
      },
    ];

    return Obx(
      () => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: (UserService.instance.isAccountAccessBlocked.value)
            ? BlockAppAccessScreen()
            : IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
        floatingActionButton: SizedBox(
          child: FloatingActionButton(
            elevation: 3,
            onPressed: () {
              // Get.to(() => CustomizeRecording());
              Get.to(() => ModeManager());
            },
            backgroundColor: Color(0xffFFD6A5),
            child: Icon(
              Icons.add,
              color: kTertiaryColor,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          child: BottomAppBar(
            height: Platform.isIOS ? null : 70,
            color: kSecondaryColor,
            notchMargin: 6.0,
            padding: AppSizes.HORIZONTAL,
            shape: CircularNotchedRectangle(),
            shadowColor: kTertiaryColor.withOpacity(0.10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(
                      icon: _currentIndex == 0
                          ? _items[0]['iconA']
                          : _items[0]['icon'],
                      isSelected: false,
                      onTap: () => _getCurrentIndex(0),
                      title: _items[0]['label'],
                    ),
                    _NavItem(
                      icon: _currentIndex == 1
                          ? _items[1]['iconA']
                          : _items[1]['icon'],
                      isSelected: false,
                      onTap: () => _getCurrentIndex(1),
                      title: _items[1]['label'],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    _NavItem(
                      icon: _currentIndex == 2
                          ? _items[2]['iconA']
                          : _items[2]['icon'],
                      isSelected: false,
                      onTap: () => _getCurrentIndex(2),
                      title: _items[2]['label'],
                    ),
                    _NavItem(
                      icon: _currentIndex == 3
                          ? _items[3]['iconA']
                          : _items[3]['icon'],
                      isSelected: false,
                      onTap: () => _getCurrentIndex(3),
                      title: _items[3]['label'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 69,
        width: 50,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 20,
              color: isSelected ? kWhiteColor : kWhiteColor.withOpacity(0.8),
            ),
            MyText(
              paddingTop: 6,
              text: title,
              size: 10,
              weight: FontWeight.w500,
              color: isSelected ? kWhiteColor : kWhiteColor.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockAppAccessScreen extends StatefulWidget {
  const BlockAppAccessScreen({super.key});

  @override
  State<BlockAppAccessScreen> createState() => _BlockAppAccessScreenState();
}

class _BlockAppAccessScreenState extends State<BlockAppAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            text: "App Access Blocked",
            size: 25,
            weight: FontWeight.w600,
          ),
          MyText(
            textAlign: TextAlign.center,
            paddingTop: 6,
            paddingBottom: 40,
            text:
                "You cannot use the app right now. Please go to HiPPA settings and enable both Mood Prints Access and Therapist Access to continue.",
            size: 15,
          ),
          MyButton(
            buttonText: "Open HiPPA Settings",
            onTap: () {
              Get.to(() => HippaScreen());
            },
          )
        ],
      ),
    );
  }
}
