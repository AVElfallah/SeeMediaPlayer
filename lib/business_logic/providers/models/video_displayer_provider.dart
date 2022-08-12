import 'package:better_player/better_player.dart';

abstract class VideoDisplayerProviderModel {
  late final BetterPlayerController videoController;
  bool isIntialized = false;

  void initialize(String path);
}
