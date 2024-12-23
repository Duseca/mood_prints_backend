import 'package:flutter/material.dart';

import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';

class AddNewTherapist extends StatelessWidget {
  const AddNewTherapist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Add New',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyTextField(
                  labelText: 'Therapist First Name',
                ),
                MyTextField(
                  labelText: 'Therapist Last Name',
                ),
                MyTextField(
                  labelText: 'Country',
                ),
                MyTextField(
                  labelText: 'State',
                ),
                MyTextField(
                  labelText: 'City',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Add New Therapist',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
