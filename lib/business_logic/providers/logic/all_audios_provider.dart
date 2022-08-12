import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:see_media_player/business_logic/providers/models/all_audios_provider.dart';
import 'package:see_media_player/data/models/audio_information.dart';
import 'package:see_media_player/data/repository/get_audios.dart';
import 'package:see_media_player/data/repository/video_sorting.dart';

class AllAudiosProvider extends ChangeNotifier
    implements AllAudiosProviderModel {
  @override
  List<AudioInformation>? audios = [];

  @override
  SortingOrder? listSortingOrder = SortingOrder.asc;

  @override
  SortingType? listSortingType = SortingType.name;

  @override
  Future<void> getAudiosFromDevice() async {
    //audios!.clear();
    var prim = await getPermission();
    if (prim) {
      var setter = await GetAllAudios().getAllAudios();
      var au = <AudioInformation>[];
      for (var video in setter) {
        var path = video['path'].toString();

        var resolution = video['resolution'].toString();
        var duration = video['duration'].toString();
        duration = duration == '00:00' ? '00:01' : duration;
        var na = path.split('/').toList();

        au.add(AudioInformation(
          path: path,
          fileName: na[na.length - 2],
          duration: duration,
          name: na.last,
          quality: resolution,
          size: video['size'],
          date: video['date_add'],
        ));
      }

      audios = au;
      sortingAudioList(listSortingType, order: listSortingOrder);
      notifyListeners();
    } else {
      await getPermission();
      return getAudiosFromDevice();
    }
  }

  @override
  Future<bool> getPermission() async {
    await Permission.storage.request();
    var permission = await Permission.storage.isGranted;
    return permission;
  }

  @override
  void sortingAudioList(SortingType? type, {SortingOrder? order}) {
    listSortingOrder = order ?? listSortingOrder;
    listSortingType = type ?? listSortingType;

    if (audios!.isEmpty) return;
    audios = Sorting<AudioInformation>()
        .sort(audios!, type: type!, order: order ?? SortingOrder.asc);
    notifyListeners();
  }
}
