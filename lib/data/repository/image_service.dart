import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ImageService {


  Future<String> createAThumbnail(Uint8List imageBytes)async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final imagePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);
      return imagePath;
    } catch (e) {
      throw Exception('Failed to create thumbnail: $e');
    }
  }
}