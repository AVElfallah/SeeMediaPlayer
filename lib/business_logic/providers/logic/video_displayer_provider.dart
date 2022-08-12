import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/video_displayer_provider.dart';

class VideoDisplayerProvider extends ChangeNotifier
    implements VideoDisplayerProviderModel {
  @override
  bool isIntialized = false;

  @override
  late BetterPlayerController videoController;

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  void initialize(String path) {
    var betterPlayerDataSource = BetterPlayerDataSource.file(path);
    videoController = BetterPlayerController(
      const BetterPlayerConfiguration(fit: BoxFit.contain, aspectRatio: 1 / 2),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    isIntialized = true;
    notifyListeners();
  }
}
