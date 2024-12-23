import 'package:flutter/material.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';

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
    );
  }
}
