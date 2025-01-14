import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/model/mood_models/feeling_model.dart';

import '../model/mood_models/mood_indicator_model.dart';

List<FeelingModel> feelingItems = [
  FeelingModel(
    iconB: Assets.imagesExtremeCrying,
    iconA: Assets.imagesExtremeCryingA,
    text: 'Extreme Crying',
  ),
  FeelingModel(
    iconB: Assets.imagesLittleCrying,
    iconA: Assets.imagesLittleCryingA,
    text: 'Little Crying',
  ),
  FeelingModel(
    iconB: Assets.imagesSad,
    iconA: Assets.imagesSadA,
    text: 'Sad',
  ),
  FeelingModel(
    iconB: Assets.imagesSad1,
    iconA: Assets.imagesSad1A,
    text: 'Sad 1',
  ),
  FeelingModel(
    iconB: Assets.imagesLittleSad,
    iconA: Assets.imagesLittleSadA,
    text: 'Little Sad',
  ),
  FeelingModel(
    iconB: Assets.imagesHappy,
    iconA: Assets.imagesHappyA,
    text: 'Happy',
  ),
  FeelingModel(
    iconB: Assets.imagesSmile,
    iconA: Assets.imagesSmileA,
    text: 'Smile',
  ),
  FeelingModel(
    iconB: Assets.imagesLittleSmiling,
    iconA: Assets.imagesLittleSmilingA,
    text: 'Little Smiling',
  ),
  FeelingModel(
    iconB: Assets.imagesLaughing,
    iconA: Assets.imagesLaughingA,
    text: 'Laughing',
  ),
];

List<MoodModel> modeIndicatorItems = [
  MoodModel(text: '-4', color: kN4Color, mode: 'Terrible', stressLevel: -4),
  MoodModel(text: '-3', color: kN3Color, mode: 'Awful', stressLevel: -3),
  MoodModel(text: '-2', color: kN2Color, mode: 'Bad', stressLevel: -2),
  MoodModel(text: '-1', color: kN1Color, mode: 'Poor', stressLevel: -1),
  MoodModel(text: '0', color: k0Color, mode: 'Neutral', stressLevel: 0),
  MoodModel(text: '1', color: kP1Color, mode: 'Fair', stressLevel: 1),
  MoodModel(text: '2', color: kP2Color, mode: 'Good', stressLevel: 2),
  MoodModel(text: '3', color: kP3Color, mode: 'Great', stressLevel: 3),
  MoodModel(text: '4', color: kP4Color, mode: 'Excellent', stressLevel: 4),
];


// List<Map<String, String>> emotionsItems = [
//   {
//     'text': 'Happy',
//     'emoji': '😊',
//   },
//   {
//     'text': 'Sad',
//     'emoji': '😢',
//   },
//   {
//     'text': 'Fear',
//     'emoji': '😨',
//   },
//   {
//     'text': 'Angry',
//     'emoji': '😡',
//   },
//   {
//     'text': 'Surprised',
//     'emoji': '😲',
//   },
//   {
//     'text': 'Disgusted',
//     'emoji': '🤢',
//   }
// ];
