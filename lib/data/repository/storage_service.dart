import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService _instance = LocalStorageService._();
  static LocalStorageService get instance => _instance;
  late final GetStorage _storage;
  ///
  /// Initialize the storage service
   setDataBase(){
     GetStorage.init('thumbnails').then((value) {
      try{
        _storage = GetStorage('thumbnails');
      }
      catch(e){
        debugPrint(e.toString());
      }
     } );
    
  }

  /// Write all videos thumbnails to the storage
  Future<void> writeAllVideosThumbnails(Map<String,String> videos) async {
    try {
      for (var video in videos.entries) {
        _storage.write(video.key, video.value);
      }
      _storage.save();
    } catch (e) {
      debugPrint(e.toString());
    }
    }


  /// Get all videos thumbnails from the storage
  /// return Map<String,String>
  Map<String,String>? getAllVideosThumbnails() {
    if(_storage.getValues() == null){
      return null;
    }
    return _storage.getValues();
  }

  /// Get custom video thumbnail from the storage
  /// return String?
  String? getCustomVideoThumbnail(String videoId) {
    if(!_storage.hasData(videoId)){
      return null;
    }
    return _storage.read(videoId);
  }

  /// Write custom video thumbnail to the storage
  /// return Future<void>
  
  Future<void> writeCustomVideoThumbnail(String videoId, String thumbnail) async {
    try {
      _storage.write(videoId, thumbnail);
      _storage.save();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// check if a custom image in a storage

Future<bool> checkIfThumbnailExists(String videoId) async {
  return _storage.hasData(videoId);
}

}