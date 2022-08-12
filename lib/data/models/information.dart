import 'dart:typed_data';

 class MediaInformation{
  String? duration;
  String? name;
  String? quality;
  String? date;
  String? fileName;
  String? size;
  String? path;
  Uint8List? thumbnail;

  MediaInformation({
    this.name,
    this.size,
    this.duration,
    this.path,
    this.quality,
    this.date,
    this.thumbnail,
    this.fileName,
  });
}