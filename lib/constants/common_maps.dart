import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/model/client_model/mood_models/feeling_model.dart';

import '../model/client_model/mood_models/mood_indicator_model.dart';

// List<FeelingModel> feelingItems = [
//   FeelingModel(
//     iconB: Assets.imagesExtremeCrying,
//     iconA: Assets.imagesExtremeCryingA,
//     text: 'Extreme Crying',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesLittleCrying,
//     iconA: Assets.imagesLittleCryingA,
//     text: 'Little Crying',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesSad,
//     iconA: Assets.imagesSadA,
//     text: 'Sad',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesSad1,
//     iconA: Assets.imagesSad1A,
//     text: 'Sad 1',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesLittleSad,
//     iconA: Assets.imagesLittleSadA,
//     text: 'Little Sad',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesHappy,
//     iconA: Assets.imagesHappyA,
//     text: 'Happy',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesSmile,
//     iconA: Assets.imagesSmileA,
//     text: 'Smile',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesLittleSmiling,
//     iconA: Assets.imagesLittleSmilingA,
//     text: 'Little Smiling',
//   ),
//   FeelingModel(
//     iconB: Assets.imagesLaughing,
//     iconA: Assets.imagesLaughingA,
//     text: 'Laughing',
//   ),
// ];

List<FeelingModel> stressItems = [
  FeelingModel(
    unselectedIcon: Assets.imagesLittleSmiling,
    selectedIcon: Assets.imagesLittleSmilingA,
    level: 0,
    text: 'little_smiling',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesHappy,
    selectedIcon: Assets.imagesHappyA,
    level: 1,
    text: 'happy',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesSad1,
    selectedIcon: Assets.imagesSad1A,
    level: 2,
    text: 'sad_1',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesLittleCrying,
    selectedIcon: Assets.imagesLittleCryingA,
    level: 3,
    text: 'little_crying',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesExtremeCrying,
    selectedIcon: Assets.imagesExtremeCryingA,
    level: 4,
    text: 'extreme_crying',
  ),
];

List<FeelingModel> irritateItems = [
  FeelingModel(
    unselectedIcon: Assets.imagesIZeroA,
    selectedIcon: Assets.imagesIZeroB,
    level: 0,
    text: 'calm',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesIOneA,
    selectedIcon: Assets.imagesIOneB,
    level: 1,
    text: 'slightly annoyed',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesITwoA,
    selectedIcon: Assets.imagesITwoB,
    level: 2,
    text: 'moderately annoyed',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesIThreeA,
    selectedIcon: Assets.imagesIThreeB,
    level: 3,
    text: 'very annoyed',
  ),
  FeelingModel(
    unselectedIcon: Assets.imagesIFourA,
    selectedIcon: Assets.imagesIFourB,
    level: 4,
    text: 'very angry',
  ),
];

List<MoodModel> modeIndicatorItems = [
  MoodModel(
      text: '-4', color: kN4Color, mode: 'Severly depressed', stressLevel: -4),
  MoodModel(text: '-3', color: kN3Color, mode: 'Very sad', stressLevel: -3),
  MoodModel(
      text: '-2', color: kN2Color, mode: 'Moderately Sad', stressLevel: -2),
  MoodModel(text: '-1', color: kN1Color, mode: 'Slightly Sad', stressLevel: -1),
  MoodModel(text: '0', color: k0Color, mode: 'Neutral', stressLevel: 0),
  MoodModel(text: '1', color: kP1Color, mode: 'Slightly Happy', stressLevel: 1),
  MoodModel(
      text: '2', color: kP2Color, mode: 'Moderately Happy', stressLevel: 2),
  MoodModel(text: '3', color: kP3Color, mode: 'Very Happy', stressLevel: 3),
  MoodModel(
      text: '4', color: kP4Color, mode: 'Extremely happy!', stressLevel: 4),
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
