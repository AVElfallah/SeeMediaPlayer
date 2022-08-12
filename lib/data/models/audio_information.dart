import 'package:see_media_player/data/models/information.dart';

class AudioInformation extends MediaInformation {
  AudioInformation({
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
}
