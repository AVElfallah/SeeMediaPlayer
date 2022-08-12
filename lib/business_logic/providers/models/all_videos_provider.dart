import 'dart:typed_data';

import 'package:see_media_player/data/models/video_information.dart';

import '../../../data/repository/video_sorting.dart';

abstract class AllVideosProviderModel {
  Future<Uint8List> getThumbnail(String videoPath);
  Future<void> getVideosFromDevice();
  Future<bool> getPermission();
  List<VideoInformation>? videos;
  bool? listOrGrid;
  void changeListOrGrid();
  void sortingVideoList(SortingType? type, {SortingOrder? order});
  SortingType? listSortingType;
  SortingOrder? listSortingOrder;
}
