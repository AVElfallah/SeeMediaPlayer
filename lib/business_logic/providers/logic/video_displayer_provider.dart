import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';


class VideoDisplayerProvider extends ChangeNotifier
    {
      VideoDisplayerProvider() {
    debugPrint('Video Displayer Provider Created');
  }

  
  bool isLoaded = false;

  late BetterPlayerController videoController;

  @override
  void dispose() {
        videoController.dispose();
    debugPrint('Video Displayer Provider Disposed');
    super.dispose();
  }

  void initialize(String path) {

    var betterPlayerDataSource = BetterPlayerDataSource.file(path);
    videoController = BetterPlayerController(
      const BetterPlayerConfiguration(fit: BoxFit.contain, aspectRatio: 1 / 2),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    isLoaded = true;
    notifyListeners();
    debugPrint('Video Displayer Provider Initialized');
  }
}
