import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Private constructor
  ImagePickerService._privateConstructor();

  // Static instance of the class
  static final ImagePickerService _instance =
      ImagePickerService._privateConstructor();

  // Factory constructor to return the same instance
  factory ImagePickerService() {
    return _instance;
  }

  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<String> activeMedia = ValueNotifier<String>('');

  Future<void> pickMedia(
      {required bool isImage, required bool fromGallery}) async {
    XFile? pickedFile;

    if (isImage) {
      pickedFile = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );
    } else {
      pickedFile = await _picker.pickVideo(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      activeMedia.value = pickedFile.path;
      log('${isImage ? 'Image' : 'Video'} picked :-----> ${activeMedia.value}');
    } else {
      displayToast(msg: '${isImage ? 'Image' : 'Video'} not picked');
      log('No ${isImage ? 'Image' : 'Video'} picked');
    }
  }

  void displayToast({required String msg}) {
    // Implement your toast display logic here
    log(msg);
  }
}
