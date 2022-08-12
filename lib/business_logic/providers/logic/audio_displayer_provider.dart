import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:see_media_player/business_logic/providers/models/audio_displayer_provider.dart';

class AudioDisplayerProvider extends ChangeNotifier
    implements AudioDisplayerProviderModel {
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Future<void> initialControllers(String path) async {
    if (controller == null) {
      controller ??= AudioPlayer()..setFilePath(path);
      controller!.load().then((_) {
        isInitialized = true;
        notifyListeners();
      });
    }
  }

  seekToSecond(double second) {
    controller!.seek(Duration(seconds: second.toInt()));

    curntSecond = controller!.position.inSeconds.toDouble();

    notifyListeners();
  }

  startAudio() {
    controller!.playing ? controller!.pause() : controller?.play();
    notifyListeners();
  }

  seekForward() {
    if (controller!.position.inSeconds > 5) {
      controller!.seek(Duration(seconds: controller!.position.inSeconds + 5));
      notifyListeners();
    }
  }

  seekBackward() {
    if (controller!.position.inSeconds > 5) {
      controller!.seek(Duration(seconds: controller!.position.inSeconds - 5));
      notifyListeners();
    }
  }

  double? curntSecond = 0;
  bool? isPlayed = false;
  bool? isInitialized = false;

  @override
  AudioPlayer? controller;
}
