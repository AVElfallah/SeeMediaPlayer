import 'package:see_media_player/data/models/audio_information.dart';

import '../../../data/repository/video_sorting.dart';

abstract class AllAudiosProviderModel {
  Future<void> getAudiosFromDevice();

  Future<bool> getPermission();

  List<AudioInformation>? audios;

  void sortingAudioList(SortingType? type, {SortingOrder? order});

  SortingType? listSortingType;
  SortingOrder? listSortingOrder;
}
