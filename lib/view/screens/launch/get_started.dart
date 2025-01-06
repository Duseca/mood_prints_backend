import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/client_sign_up.dart';
import 'package:mood_prints/view/screens/auth/sign_up/sign_up.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class GetStarted extends StatefulWidget {
  GetStarted({
    super.key,
  });

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  PageController _controller = PageController();

  int _index = 0;

  @override
  void initState() {
    // TODO: OnBoarding display only once
    super.initState();
    checkingOnBoardingPage();
  }

  void checkingOnBoardingPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isCompleted = await prefs.getBool('isOnBoardingCompleted');
    if (isCompleted == true) {
      _index = 3;
      log('Checking OnBoarding Page $_index');
      log('Checking OnBoarding Value $isCompleted');
    } else {
      _index = 0;
      log('Checking OnBoarding Page $_index');
      log('Checking OnBoarding Value $isCompleted');
    }
  }

  void _onChanged(int index) async {
    setState(() {
      // Here i want to call

      _index = index;
    });
    if (_index == 3) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isOnBoardingCompleted', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      {
        'title': 'Track Your Moods Daily',
        'subTitle':
            'Easily record your emotions and feelings each day. Discover how your mood fluctuates over time and start your journey to better mental health.',
        // 'image': Assets.imagesOn1,
      },
      {
        'title': 'Uncover Mood Patterns',
        'subTitle':
            'Identify trends and patterns in your emotional well-being. Gain insights that help you understand the triggers behind your moods.',
        // 'image': Assets.imagesOn2,
      },
      {
        'title': 'Connect with Your Therapist',
        'subTitle':
            'Share your mood insights with your therapist for more personalized support. Together, work towards better mental health.',
        // 'image': Assets.imagesOn1,
      },
      {
        'title': 'Select Your User Type',
        'subTitle':
            'Choose the option that best describes your role. This will help us tailor your experience.',
        // 'image': Assets.imagesOn1,
      },
    ];
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Padding(
        padding: AppSizes.VERTICAL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
            ),
            Expanded(
              flex: 6,
              child: Padding(
                  padding: AppSizes.HORIZONTAL,
                  child: Container(
                    color: Colors.blueGrey,
                  )
                  // CommonImageView(
                  //   height: Get.height,
                  //   width: Get.width,
                  //   radius: 12,
                  //   fit: BoxFit.cover,
                  //   imagePath: Assets.imagesGetStarted,
                  // ),
                  ),
            ),
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: _index == 3
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                itemCount: _items.length,
                onPageChanged: (index) => _onChanged(index),
                controller: _controller,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: AppSizes.HORIZONTAL,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: _items[index]['title'],
                          size: 22,
                          weight: FontWeight.bold,
                        ),
                        MyText(
                          paddingTop: 8,
                          text: _items[index]['subTitle'],
                          size: 14,
                          weight: FontWeight.w400,
                          color: kGreyColor2,
                          lineHeight: 1.5,
                          paddingBottom: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_index != 3)
              Padding(
                padding: AppSizes.DEFAULT,
                child: SmoothPageIndicator(
                  count: 3,
                  controller: _controller,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 4.0,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 3.0,
                    activeDotColor: kSecondaryColor,
                    dotColor: kSecondaryColor.withOpacity(0.5),
                  ), // your preferred effect
                  onDotClicked: (index) {},
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (_index == 3) ...[
              Padding(
                padding: AppSizes.HORIZONTAL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyButton(
                      buttonText: 'I am a client',
                      onTap: () {
                        Get.to(() => ClientSignUp(type: "client"));
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MyButton(
                      buttonText: 'I am a therapist',
                      onTap: () {
                        Get.to(() => SignUp());
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MyButton(
                      buttonText: 'I am an independent user',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ] else
              Padding(
                padding: AppSizes.HORIZONTAL,
                child: MyButton(
                  buttonText: _index == 0
                      ? 'Get Started'
                      : _index == 2
                          ? 'Let\'s Begin'
                          : 'Next',
                  onTap: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
