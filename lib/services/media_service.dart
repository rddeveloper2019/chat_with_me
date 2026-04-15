import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  MediaService();

  Future<File?> pickImageFromLibrary() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile platformFile = result.files.first;

        if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
          debugPrint(
            'Создаем файл из байтов. Размер: ${platformFile.bytes!.length} байт',
          );
          return await _saveBytesToTempFile(
            platformFile.bytes!,
            platformFile.name,
          );
        }

        if (platformFile.path != null && platformFile.path!.isNotEmpty) {
          File file = File(platformFile.path!);

          bool exists = await file.exists();
          if (exists) {
            debugPrint('Файл найден по пути: ${platformFile.path}');
            return file;
          } else {
            debugPrint('Файл не существует по пути: ${platformFile.path}');
          }
        }

        debugPrint('Не удалось получить изображение: нет пути или байтов');
        return null;
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка выбора изображения: $e');
      return null;
    }
  }

  Future<File> _saveBytesToTempFile(Uint8List bytes, String fileName) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      final String uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final String filePath = '${tempDir.path}/$uniqueName';

      final File tempFile = File(filePath);
      final compressedBytes = await _compressImage(bytes);
      debugPrint('Сжато до: ${compressedBytes.length} байт');
      await tempFile.writeAsBytes(compressedBytes);

      debugPrint('Создан временный файл: $filePath');
      return tempFile;
    } catch (e) {
      debugPrint('Ошибка сохранения временного файла: $e');
      rethrow;
    }
  }

  Future<void> cleanupTempFiles() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final List<FileSystemEntity> files = tempDir.listSync();

      final DateTime now = DateTime.now();
      for (final file in files) {
        final stat = await file.stat();
        final age = now.difference(stat.modified);

        if (age.inHours > 24) {
          await file.delete();
          debugPrint('Удален старый файл: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint('Ошибка очистки временных файлов: $e');
    }
  }
}

Future<Uint8List> _compressImage(Uint8List imageData) async {
  return await compute(_compressImageIsolate, imageData);
}

Uint8List _compressImageIsolate(Uint8List data) {
  final img = decodeImage(data);
  return encodeJpg(img!, quality: 70);
}
