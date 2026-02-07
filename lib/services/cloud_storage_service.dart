import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

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

  // Future<String?> saveUserImageToStorage({
  //   required String uid,
  //   required PlatformFile file,
  // }) async {
  //   try {
  //     Reference reference = _storage.ref().child(
  //       'images/$USERS_COLLECTION/$uid/profile.${file.extension}',
  //     );
  //     final metadata = SettableMetadata(
  //       contentType: 'image/${file.extension}',
  //       customMetadata: {'uploaded_by': uid},
  //     );
  //     print('images/$USERS_COLLECTION/$uid/profile.${file.extension}');
  //     print('(**) => file.size:  ${file.size}');
  //     final uploadTask = reference.putFile(File(file.path!), metadata);
  //     await uploadTask.whenComplete(() {});
  //     return await reference.getDownloadURL();
  //   } on FirebaseException catch (e) {
  //     print("FirebaseException saveUserImage:  ${e.toString()}");
  //   } catch (e) {
  //     print("CloudStorageService saveUserImage:  ${e.toString()}");
  //   }
  // }

  Future<String?> saveUserImageToStorage({
    required String uid,
    required PlatformFile file,
  }) async {
    try {
      // Проверка файла
      if (file.path == null || !await File(file.path!).exists()) {
        print('Файл не существует');
        return null;
      }

      // Проверка размера файла
      if (file.size > 5 * 1024 * 1024) {
        print('Файл слишком большой, сжатие...');
        final compressedFile = await compressImage(file.path!);
        if (compressedFile == null) return null;
        file = PlatformFile(
          path: compressedFile.path,
          size: await compressedFile.length(),
          name: file.name,
        );
      }

      Reference reference = _storage.ref().child(
        'images/$USERS_COLLECTION/$uid/profile.${file.extension}',
      );

      // Загрузка с таймаутом
      final uploadTask = reference.putFile(
        File(file.path!),
        SettableMetadata(
          contentType: 'image/${file.extension}',
          cacheControl: 'public, max-age=31536000',
        ),
      );

      // Таймаут 60 секунд
      final snapshot = await uploadTask.timeout(
        Duration(seconds: 60),
        onTimeout: () {
          print('Таймаут загрузки');
          uploadTask.cancel();
          throw TimeoutException('Превышено время загрузки');
        },
      );

      // Проверка успешной загрузки
      if (snapshot.state == TaskState.success) {
        final url = await reference.getDownloadURL();
        print('Изображение загружено: $url');
        return url;
      } else {
        print('Ошибка загрузки: ${snapshot.state}');
        return null;
      }
    } on FirebaseException catch (e) {
      print("FirebaseException saveUserImage: ${e.code} - ${e.message}");

      // Обработка специфичных ошибок
      if (e.code == 'canceled') {
        print('Загрузка отменена');
      } else if (e.code == 'unknown') {
        print('Неизвестная ошибка, проверьте интернет соединение');
      }
    } on TimeoutException catch (e) {
      print('Таймаут: $e');
    } catch (e) {
      print("CloudStorageService saveUserImage: $e");
    }

    return null;
  }

  Future<String?> saveChatImageToStorage({
    required String uid,
    required String chatId,
    required PlatformFile file,
  }) async {
    try {
      Reference reference = _storage.ref().child(
        'images/$CHATS_COLLECTION/$chatId/${uid}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}',
      );

      final result = await reference.putFile(File(file.path!));

      return result.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("FirebaseException saveChatImage:  ${e.toString()}");
    } catch (e) {
      print("CloudStorageService saveChatImage:  ${e.toString()}");
    }
  }
}
