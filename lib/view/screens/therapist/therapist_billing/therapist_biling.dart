import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class TherapistBilling extends StatelessWidget {
  const TherapistBilling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Billing',
        centerTitle: false,
        haveLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: AppStyling.CUSTOM_CARD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'My Subscription',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 6,
                ),
                MyText(
                  text: 'You can renew subscription anytime.',
                  size: 12,
                  color: kGreyColor,
                  paddingBottom: 8,
                ),
                _CustomTile(
                  title: 'My Plan',
                  subTitle: 'Basic',
                ),
                _CustomTile(
                  title: 'Clients',
                  subTitle: '1 Client',
                ),
                _CustomTile(
                  title: 'Charges',
                  subTitle: '\$4.16',
                ),
                _CustomTile(
                  title: 'Billing Cycle',
                  subTitle: 'Weekly',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: AppStyling.CUSTOM_CARD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'New Packages',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 6,
                ),
                MyText(
                  text: 'You can switch to new plan anytime.',
                  size: 12,
                  color: kGreyColor,
                  paddingBottom: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _CustomCard(
                        planName: 'Basic Plan',
                        clients: '1 Clients',
                        price: '\$4.16',
                        planType: 'Weekly',
                        isSelected: true,
                        haveSparkle: true,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: _CustomCard(
                        planName: 'Standard Plan',
                        clients: '4 Clients',
                        price: '\$14.00',
                        planType: 'Weekly',
                        isSelected: false,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                _CustomCard(
                  planName: 'Business Plan',
                  clients: '10 Clients',
                  price: '\$30.50',
                  planType: 'Weekly',
                  isSelected: false,
                  onTap: () {},
                ),
                SizedBox(
                  height: 12,
                ),
                _CustomCard(
                  planName: 'Enterprise Plan',
                  clients: 'Up to 25 Clients',
                  price: '\$65',
                  planType: 'Weekly',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: AppStyling.CUSTOM_CARD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Billing',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 6,
                ),
                MyText(
                  text: 'Here is the record of all your billing.',
                  size: 12,
                  color: kGreyColor,
                  paddingBottom: 8,
                ),
                _CustomTile2(
                  title: 'Basic Plan',
                  subTitle: '14/09/2024',
                  trailing: '\$-4.16',
                ),
                _CustomTile2(
                  title: 'Basic Plan',
                  subTitle: '14/09/2024',
                  trailing: '\$-4.16',
                ),
                _CustomTile2(
                  title: 'Basic Plan',
                  subTitle: '14/09/2024',
                  trailing: '\$-4.16',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: title,
          ),
          MyText(
            text: subTitle,
            size: 16,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _CustomTile2 extends StatelessWidget {
  const _CustomTile2({
    super.key,
    required this.title,
    required this.subTitle,
    required this.trailing,
  });

  final String title;
  final String subTitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: title,
                  paddingBottom: 2,
                ),
                MyText(
                  text: subTitle,
                  color: kGreyColor,
                ),
              ],
            ),
          ),
          MyText(
            text: trailing,
            size: 14,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard({
    super.key,
    required this.planName,
    required this.clients,
    required this.price,
    required this.planType,
    required this.isSelected,
    required this.onTap,
    this.haveSparkle = false,
  });

  final String planName;
  final String clients;
  final String price;
  final String planType;
  final bool isSelected;
  final bool? haveSparkle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1.0,
            color: kSecondaryColor,
          ),
          color: isSelected
              ? kSecondaryColor.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MyText(
                  text: planName,
                  size: 16,
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                  paddingBottom: 14,
                ),
                if (haveSparkle!)
                  Positioned(
                    top: -4,
                    right: -16,
                    child: Image.asset(
                      Assets.imagesSparkle,
                      height: 16,
                    ),
                  ),
              ],
            ),
            MyText(
              text: clients,
              paddingBottom: 8,
            ),
            MyText(
              text: price,
              paddingBottom: 8,
            ),
            MyText(
              text: planType,
            ),
          ],
        ),
      ),
    );
  }
}
