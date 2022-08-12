import 'dart:io';

import 'package:video_player/video_player.dart';

import 'information.dart';

class VideoInformation extends MediaInformation {
  VideoInformation({
    name,
    size,
    duration,
    path,
    quality,
    date,
    thumbnail,
    fileName,
  }) : super(
          name: name,
          size: size,
          duration: duration,
          path: path,
          quality: quality,
          date: date,
          thumbnail: thumbnail,
          fileName: fileName,
        );

  VideoPlayerController getVideoPlayerController() =>
      VideoPlayerController.file(File(path!));
}
