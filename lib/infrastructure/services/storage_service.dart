import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for handling file uploads to Firebase Storage.
class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads a profile photo for the given user and returns the download URL.
  ///
  /// The image is stored at `profile_photos/{userId}/avatar.jpg`.
  /// Returns the public download URL of the uploaded file.
  Future<String> uploadProfilePhoto(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_photos/$userId/avatar.jpg');

      // Upload the file
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('Profile photo uploaded: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('Failed to upload profile photo: $e');
      throw Exception('Failed to upload profile photo: $e');
    }
  }
}
