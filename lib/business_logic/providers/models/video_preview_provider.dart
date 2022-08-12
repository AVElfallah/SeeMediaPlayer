import 'dart:typed_data';

abstract class VideoPreviewProviderModel {
  late final String? path;
  Uint8List? image;

  Future<void> setImagePyPath();
}
