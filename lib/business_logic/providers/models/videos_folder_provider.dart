import 'dart:typed_data';

import '../../../data/models/video_information.dart';

abstract class VideosFolderProviderModel {
  Future<void> getVideosFromDevice();
  Future<bool> getPermission();
  Map<String, List<VideoInformation>>? videos;
  Future<Uint8List> getVideoThumbnail(String path);
}
