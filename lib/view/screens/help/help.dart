import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/faq_tile_widget.dart';
import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Help Center',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          FaqTile(
            title: 'Lorem Ipsum Dolor',
            subTitle:
                'Integer posuere, velit sit amet aliquam posuere, odio odio mattis mi, vel dictum magna turpis vitae arcu. Sed quis ultrices neque. Vivamus ullamcorper arcu non erat laoreet, vel rhoncus quam volutpat.',
          ),
          FaqTile(
            title: 'Lorem Ipsum Dolor',
            subTitle:
                'Integer posuere, velit sit amet aliquam posuere, odio odio mattis mi, vel dictum magna turpis vitae arcu. Sed quis ultrices neque. Vivamus ullamcorper arcu non erat laoreet, vel rhoncus quam volutpat.',
          ),
          FaqTile(
            title: 'Lorem Ipsum Dolor',
            subTitle:
                'Integer posuere, velit sit amet aliquam posuere, odio odio mattis mi, vel dictum magna turpis vitae arcu. Sed quis ultrices neque. Vivamus ullamcorper arcu non erat laoreet, vel rhoncus quam volutpat.',
          ),
          FaqTile(
            title: 'Lorem Ipsum Dolor',
            subTitle:
                'Integer posuere, velit sit amet aliquam posuere, odio odio mattis mi, vel dictum magna turpis vitae arcu. Sed quis ultrices neque. Vivamus ullamcorper arcu non erat laoreet, vel rhoncus quam volutpat.',
          ),
          FaqTile(
            title: 'Lorem Ipsum Dolor',
            subTitle:
                'Integer posuere, velit sit amet aliquam posuere, odio odio mattis mi, vel dictum magna turpis vitae arcu. Sed quis ultrices neque. Vivamus ullamcorper arcu non erat laoreet, vel rhoncus quam volutpat.',
          ),
        ],
      ),
    );
  }
}
