import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

const USERS_COLLECTION = 'users';
const CHATS_COLLECTION = 'chats';

Future<File?> compressImage(String path) async {
  final imageFile = File(path);
  final bytes = await imageFile.readAsBytes();
  final image = img.decodeImage(bytes);

  if (image != null) {
    final compressed = img.copyResize(image, width: 1024);
    final compressedBytes = img.encodeJpg(compressed, quality: 85);

    final tempDir = await getTemporaryDirectory();
    final compressedPath =
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(compressedPath).writeAsBytes(compressedBytes);

    return File(compressedPath);
  }
  return null;
}

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> saveChatImageToStorage({
    required String uid,

    required File file,
  }) async {
    try {
      Uint8List fileBytes = await file.readAsBytes();

      String? mimeType = lookupMimeType(file.path);
      String fileExtension = 'jpg';

      if (mimeType != null) {
        switch (mimeType) {
          case 'image/jpeg':
            fileExtension = 'jpg';
            break;
          case 'image/png':
            fileExtension = 'png';
            break;
          case 'image/gif':
            fileExtension = 'gif';
            break;
          case 'image/webp':
            fileExtension = 'webp';
            break;
          default:
            fileExtension = path.extension(file.path).replaceAll('.', '');
            if (fileExtension.isEmpty) fileExtension = 'jpg';
        }
      } else {
        fileExtension = path.extension(file.path).replaceAll('.', '');
        if (fileExtension.isEmpty) fileExtension = 'jpg';
      }

      String fileName =
          '${uid}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      Reference reference = _storage.ref().child(
        'images/$USERS_COLLECTION/$uid/$fileName',
      );

      UploadTask uploadTask = reference.putData(
        fileBytes,
        SettableMetadata(contentType: mimeType ?? 'image/jpeg'),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      debugPrint("FirebaseException saveChatImage: ${e.message}");
      return null;
    } catch (e) {
      debugPrint("CloudStorageService saveChatImage: $e");
      return null;
    }
  }
}
