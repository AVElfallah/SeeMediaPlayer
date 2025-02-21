import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:see_media_player/data/models/video_information.dart';
import 'package:see_media_player/data/repository/get_video_thumbnail.dart';
import 'package:see_media_player/data/repository/video_sorting.dart';

import '../../../data/repository/get_videos.dart';

class AllVideosProvider extends ChangeNotifier
     {
  Future<bool> getPermission() async {
    debugPrint('getPermission');
    await Permission.storage.request();
    var permission = await Permission.storage.isGranted;
    return permission;
  }

  Future<Uint8List> getThumbnail(String videoPath) async {
    debugPrint('getThumbnail');
    var prim = await getPermission();
    if (prim) {
      var thumbnail = await GetVideoThumbnail().getThumbnail(videoPath);
      return thumbnail;
    } else {
      await getPermission();
      return await getThumbnail(videoPath);
    }
  }

  Future<void> getVideosFromDevice() async {
    debugPrint('getVideosFromDevice');
    var prim = await getPermission();
    if (prim) {
      var setter = await GetAllVideos().getAllVideos();
      var vid = <VideoInformation>[];
      for (var video in setter) {
        var path = video['path'].toString();

        var resolution = video['resolution'].toString();

        var na = path.split('/').toList();
        var duration = video['duration'].toString();
        duration = duration == '00:00' ? '00:01' : duration;
        vid.add(VideoInformation(
          path: path,
          fileName: na[na.length - 2],
          duration: duration,
          name: na.last,
          quality: resolution,
          size: video['size'],
          date: video['date_add'],
        ));
      }

      videos = vid;
      sortingVideoList(listSortingType, order: listSortingOrder);
      notifyListeners();
    } else {
      await getPermission();
      return getVideosFromDevice();
    }
  }

  
  List<VideoInformation> videos = [];

  bool isAList = true;

  void changeListState() {
    isAList = !isAList;
    notifyListeners();
  }

  void sortingVideoList(SortingType? type, {SortingOrder? order}) {
    listSortingOrder = order ?? listSortingOrder;
    listSortingType = type ?? listSortingType;
    if (videos.isEmpty) return;
    videos = Sorting<VideoInformation>()
        .sort(videos, type: type!, order: order ?? SortingOrder.asc);
    notifyListeners();
  }

  SortingOrder listSortingOrder = SortingOrder.dsc;

  
  SortingType listSortingType = SortingType.name;
}
