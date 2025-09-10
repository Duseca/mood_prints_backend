import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/faqs_controller.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/faq_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Help Center',
      ),
      body: GetBuilder<FaqsController>(
          id: "faqs",
          builder: (controller) {
            return controller.loading
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                        color: kSecondaryColor, size: 150))
                : controller.faqs.isEmpty
                    ? Center(child: MyText(text: "No FAQs found"))
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: AppSizes.DEFAULT,
                        itemCount: controller.faqs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FaqTile(
                            title: controller.faqs[index].question,
                            subTitle: controller.faqs[index].answer,
                          );
                        },
                      );
          }),
    );
  }
}
