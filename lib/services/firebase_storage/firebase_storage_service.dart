import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  // Private constructor for singleton
  FirebaseStorageService._privateConstructor();

  // Singleton instance
  static final FirebaseStorageService instance =
      FirebaseStorageService._privateConstructor();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// Uploads an image to Firebase Cloud Storage
  ///
  /// - [imagePath]: Local file path of the image to upload.
  /// - [storageFolderPath]: Firebase Storage folder path where the image will be stored.
  ///
  /// Returns the download URL of the uploaded image or null if upload fails.
  Future<String?> uploadImage({
    required String imagePath,
    required String storageFolderPath,
  }) async {
    if (imagePath.isEmpty) {
      debugPrint('No image selected for upload.');
      return null;
    }

    try {
      String fileName = imagePath.split('/').last;
      String fullPath = '$storageFolderPath/$fileName';

      Reference storageReference = _firebaseStorage.ref().child(fullPath);
      UploadTask uploadTask = storageReference.putFile(File(imagePath));

      // Wait for the upload task to complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Image uploaded successfully. Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error occurred while uploading image: $e');
      return null;
    }
  }
}
