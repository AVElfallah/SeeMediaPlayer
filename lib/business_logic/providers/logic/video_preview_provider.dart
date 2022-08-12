import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:see_media_player/data/repository/get_video_thumbnail.dart';

import '../models/video_preview_provider.dart';

class VideoPreviewProvider extends ChangeNotifier
    implements VideoPreviewProviderModel {
  VideoPreviewProvider({this.path});
  @override
  late final String? path;
  @override
  Uint8List? image = Uint8List(0);

  @override
  Future<void> setImagePyPath() async {
    image = await GetVideoThumbnail().getThumbnail(path!);
    notifyListeners();
  }
}
