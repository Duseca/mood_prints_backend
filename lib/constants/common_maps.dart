import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';

List<Map<String, String>> feelingItems = [
  {'iconB': Assets.imagesExtremeCrying, 'iconA': Assets.imagesExtremeCryingA},
  {'iconB': Assets.imagesLittleCrying, 'iconA': Assets.imagesLittleCryingA},
  {'iconB': Assets.imagesSad, 'iconA': Assets.imagesSadA},
  {'iconB': Assets.imagesSad1, 'iconA': Assets.imagesSad1A},
  {'iconB': Assets.imagesLittleSad, 'iconA': Assets.imagesLittleSadA},
  {
    'iconB': Assets.imagesHappy,
    'iconA': Assets.imagesHappyA,
  },
  {
    'iconB': Assets.imagesSmile,
    'iconA': Assets.imagesSmileA,
  },
  {
    'iconB': Assets.imagesLittleSmiling,
    'iconA': Assets.imagesLittleSmilingA,
  },
  {
    'iconB': Assets.imagesLaughing,
    'iconA': Assets.imagesLaughingA,
  }
];

List<Map<String, dynamic>> modeIndicatorItems = [
  {
    'text': '-4',
    'color': kN4Color,
    'mode': 'Terrible',
  },
  {
    'text': '-3',
    'color': kN3Color,
    'mode': 'Awful',
  },
  {
    'text': '-2',
    'color': kN2Color,
    'mode': 'Bad',
  },
  {
    'text': '-1',
    'color': kN1Color,
    'mode': 'Poor',
  },
  {
    'text': '0',
    'color': k0Color,
    'mode': 'Neutral',
  },
  {
    'text': '1',
    'color': kP1Color,
    'mode': 'Fair',
  },
  {
    'text': '2',
    'color': kP2Color,
    'mode': 'Good',
  },
  {
    'text': '3',
    'color': kP3Color,
    'mode': 'Great',
  },
  {
    'text': '4',
    'color': kP4Color,
    'mode': 'Excellent',
  },
];

List<Map<String, String>> emotionsItems = [
  {
    'text': 'Happy',
    'emoji': '😊',
  },
  {
    'text': 'Sad',
    'emoji': '😢',
  },
  {
    'text': 'Fear',
    'emoji': '😨',
  },
  {
    'text': 'Angry',
    'emoji': '😡',
  },
  {
    'text': 'Surprised',
    'emoji': '😲',
  },
  {
    'text': 'Disgusted',
    'emoji': '🤢',
  }
];
