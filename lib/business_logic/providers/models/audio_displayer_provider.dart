// ignore_for_file: unused_field

import 'package:just_audio/just_audio.dart';

abstract class AudioDisplayerProviderModel {
  late final AudioPlayer? controller;

  // late final ChewieAudioController? audioController;

  Future<void> initialControllers(String path);
}
