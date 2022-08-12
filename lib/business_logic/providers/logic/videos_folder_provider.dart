import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:see_media_player/business_logic/providers/models/videos_folder_provider.dart';

import '../../../data/models/video_information.dart';
import '../../../data/repository/get_video_thumbnail.dart';
import '../../../data/repository/get_videos.dart';

class VideosFolderProvider extends ChangeNotifier
    implements VideosFolderProviderModel {
  @override
  Map<String, List<VideoInformation>>? videos = {};

  @override
  Future<bool> getPermission() async {
    await Permission.storage.request();
    var permission = await Permission.storage.isGranted;
    return permission;
  }

  @override
  Future<void> getVideosFromDevice() async {
    var prim = await getPermission();
    if (prim) {
      _getVideosFromDevice();
    } else {
      await getPermission();
      return getVideosFromDevice();
    }
  }

  Future<void> _getVideosFromDevice() async {
    var setter =
        await GetAllVideos().getAllVideos(); //get all videos from device

    var mapVideo = <String, List<VideoInformation>>{}; //init map of videos

    for (var video in setter) {
      final path = video['path'].toString();
      final pl = path.split('/').toList();
      //split path to get folder name
      var folder = pl[pl.length - 2];

      var duration = video['duration'].toString();
      duration = duration == '00:00' ? '00:01' : duration;
      //if folder not in map add it
      mapVideo.putIfAbsent(folder, () => []);

      //add video to folder
      mapVideo[folder]!.add(
        VideoInformation(
          path: path, //path to video
          //   fileName: video['fileName'].toString(), //file name of video
          duration: duration, //duration of video
          name: pl.last, //name of video
          fileName: pl[pl.length - 2], //file name of video
          quality: video['resolution'].toString(), //quality of video
          size: video['size'].toString(), //size of video
          date: video['date_add'].toString(), //date of video
        ),
      );
    }
    //  print(videos!.values.toList()[0][0].path);

    videos = mapVideo;
    notifyListeners();
  }

  @override
  Future<Uint8List> getVideoThumbnail(String path) async {
    var prim = await getPermission();
    if (prim) {
      return await GetVideoThumbnail().getThumbnail(path);
    } else {
      await getPermission();
      return getVideoThumbnail(path);
    }
  }
}
