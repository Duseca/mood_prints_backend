// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mood_prints/constants/app_colors.dart';
// import 'package:mood_prints/constants/app_sizes.dart';
// import 'package:mood_prints/view/screens/bottom_nav_bar/client_nav_bar.dart';
// import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
// import 'package:mood_prints/view/widget/my_button_widget.dart';
// import 'package:mood_prints/view/widget/my_text_field_widget.dart';
// import 'package:mood_prints/view/widget/my_text_widget.dart';

// class FillTherapistDetails extends StatelessWidget {
//   const FillTherapistDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: simpleAppBar(
//         title: 'Fill Therapist Details',
//         actions: [
//           Center(
//             child: MyText(
//               text: 'SKip',
//               color: kSecondaryColor,
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: ListView(
//               shrinkWrap: true,
//               padding: AppSizes.DEFAULT,
//               physics: BouncingScrollPhysics(),
//               children: [
//                 MyTextField(
//                   labelText: 'Therapist First Name',
//                 ),
//                 MyTextField(
//                   labelText: 'Therapist Last Name',
//                 ),
//                 MyTextField(
//                   labelText: 'Country',
//                 ),
//                 MyTextField(
//                   labelText: 'State',
//                 ),
//                 MyTextField(
//                   labelText: 'City',
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: AppSizes.DEFAULT,
//             child: MyButton(
//               buttonText: 'Save',
//               onTap: () {
//                 Get.to(() => ClientNavBar());
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
