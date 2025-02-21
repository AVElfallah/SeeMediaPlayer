import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';

class AudioDisplayerProvider extends ChangeNotifier
   {
  
  
  AudioDisplayerProvider() {
    debugPrint('Audio Displayer Provider Created');
  }

  @override
  void dispose() {
    debugPrint('Audio Displayer Provider Disposed');
    _audioPlayerController?.dispose();
    super.dispose();
   
  }

  Future<void> initialControllers(String path) async {
    debugPrint('Audio Displayer Provider Initialized');
   
     _audioPlayerController??= AudioPlayer()..setFilePath(path);
      _audioPlayerController!.load().then((_) {
        isInitialized = true;
        notifyListeners();
      });
    
   
  }

  seekToSecond(double second) {
    _audioPlayerController!.seek(Duration(seconds: second.toInt()));

    currentSecond = _audioPlayerController!.position.inSeconds.toDouble();

    notifyListeners();
  }

  playPauseAudio() {
    _audioPlayerController!.playing ? _audioPlayerController!.pause() : _audioPlayerController?.play();
    isPlaying = _audioPlayerController!.playing;
    notifyListeners();
  }

  seekForward() {
    if (_audioPlayerController!.position.inSeconds > 5) {
      _audioPlayerController!.seek(Duration(seconds: _audioPlayerController!.position.inSeconds + 5));
      notifyListeners();
    }
  }

  seekBackward() {
    if (_audioPlayerController!.position.inSeconds > 5) {
      _audioPlayerController!.seek(Duration(seconds: _audioPlayerController!.position.inSeconds - 5));
      notifyListeners();
    }
  }

  void setLoopMode(LoopMode loopMode) {
    _audioPlayerController?.setLoopMode(loopMode);
  }

  double currentSecond = 0;
  bool isPlaying = false;
  bool isInitialized = false;

  get positionStream => _audioPlayerController?.positionStream??const Stream.empty();

double  get durationInSeconds =>( _audioPlayerController?.duration?.inSeconds??0).toDouble();

  AudioPlayer? _audioPlayerController;

 // get controller => _audioPlayerController??= AudioPlayer();
}
