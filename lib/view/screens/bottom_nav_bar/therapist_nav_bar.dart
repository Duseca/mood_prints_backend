import 'dart:io';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/view/screens/chat/chat_head.dart';
import 'package:mood_prints/view/screens/profile/profile.dart';
import 'package:mood_prints/view/screens/therapist/therapist_billing/therapist_biling.dart';
import 'package:mood_prints/view/screens/therapist/therapist_home/therapist_client.dart';

// ignore: must_be_immutable
class TherapistNavBar extends StatefulWidget {
  @override
  _TherapistNavBarState createState() => _TherapistNavBarState();
}

class _TherapistNavBarState extends State<TherapistNavBar> {
  int _currentIndex = 0;
  void _getCurrentIndex(int index) => setState(() {
        _currentIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      // {
      //   'icon': Assets.imagesHome,
      //   'iconA': Assets.imagesHomeA,
      //   'label': 'Home',
      // },
      {
        'icon': Assets.imagesClientA,
        'iconA': Assets.imagesClientB,
        'label': 'Client',
      },
      {
        'icon': Assets.imagesChat,
        'iconA': Assets.imagesChatA,
        'label': 'Chat',
      },
      {
        'icon': Assets.imagesBill,
        'iconA': Assets.imagesBillA,
        'label': 'Billing',
      },

      {
        'icon': Assets.imagesProfile,
        'iconA': Assets.imagesProfileA,
        'label': 'Profile',
      },
    ];

    final List<Widget> _screens = [
      // TherapistHome(),
      TherapistClient(),
      ChatHead(),
      TherapistBilling(),
      Profile(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: Platform.isIOS ? null : 70,
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 30,
              spreadRadius: -2,
              color: kTertiaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          backgroundColor: Colors.transparent,
          selectedItemColor: kWhiteColor,
          unselectedItemColor: kWhiteColor.withOpacity(0.8),
          currentIndex: _currentIndex,
          onTap: (index) => _getCurrentIndex(index),
          items: List.generate(
            _items.length,
            (index) {
              var data = _items[index];
              return BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage(
                      _currentIndex == index ? data['iconA'] : data['icon'],
                    ),
                    size: 20,
                  ),
                ),
                label: data['label'].toString().tr,
              );
            },
          ),
        ),
      ),
    );
  }
}
