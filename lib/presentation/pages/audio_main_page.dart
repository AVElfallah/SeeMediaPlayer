import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/business_logic/providers/logic/all_audios_provider.dart';

import '../../data/models/audio_information.dart';
import '../../data/repository/video_sorting.dart';

class AudioMainPage extends StatefulWidget {
  const AudioMainPage({Key? key}) : super(key: key);

  @override
  State<AudioMainPage> createState() {
    return _AudioMainPageState();
  }
}

class _AudioMainPageState extends State<AudioMainPage> {
  List<AudioInformation>? audiols = <AudioInformation>[];
  SortingOrder? listSortingOrder = SortingOrder.asc;
  SortingType? listSortingType = SortingType.name;
  @override
  void initState() {
    super.initState();
    Provider.of<AllAudiosProvider>(context, listen: false)
        .getAudiosFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    audiols = Provider.of<AllAudiosProvider>(context, listen: true).audios!;
    try {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    icon: const Icon(
                      FontAwesomeIcons.youtube,
                      //   color: Colors.red,
                    ),
                    highlightColor: Colors.red.shade700,
                    splashColor: Colors.amber,
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () async {},
                    icon: const Icon(
                      FontAwesomeIcons.music,
                      color: Colors.red,
                    ),
                    highlightColor: Colors.red,
                    splashColor: Colors.amber,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PopupMenuButton(
                    onSelected: (st) {
                      switch (st) {
                        case 'name':
                          listSortingType = SortingType.name;
                          break;
                        case 'date':
                          listSortingType = SortingType.date;
                          break;
                        case 'size':
                          listSortingType = SortingType.size;
                          break;
                        case 'duration':
                          listSortingType = SortingType.duration;
                          break;
                      }
                      Provider.of<AllAudiosProvider>(
                        context,
                        listen: false,
                      ).sortingAudioList(
                        listSortingType,
                        order: listSortingOrder,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    position: PopupMenuPosition.under,
                    icon: const Icon(
                      FontAwesomeIcons.filter,
                      color: Colors.black54,
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'name',
                        child: Text('Sort by Name'),
                      ),
                      const PopupMenuItem(
                        value: 'date',
                        child: Text('Sort by Date'),
                      ),
                      const PopupMenuItem(
                        value: 'size',
                        child: Text('Sort by Size'),
                      ),
                      const PopupMenuItem(
                        value: 'duration',
                        child: Text('Sort by Duration'),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    onSelected: (st) {
                      switch (st) {
                        case 'asc':
                          listSortingOrder = SortingOrder.asc;
                          break;
                        case 'dsc':
                          listSortingOrder = SortingOrder.dsc;
                          break;
                      }
                      Provider.of<AllAudiosProvider>(
                        context,
                        listen: false,
                      ).sortingAudioList(
                        listSortingType,
                        order: listSortingOrder,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    position: PopupMenuPosition.under,
                    icon: const Icon(
                      FontAwesomeIcons.arrowDown19,
                      color: Colors.black54,
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'asc',
                        child: Text('Ascending'),
                      ),
                      const PopupMenuItem(
                        value: 'dsc',
                        child: Text('Descending'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => Provider.of<AllAudiosProvider>(
            context,
            listen: false,
          ).getAudiosFromDevice(),
          child: SizedBox(
            child: ListView.builder(
              itemCount: audiols!.length,
              itemBuilder: (_, i) => ListTile(
                style: ListTileStyle.list,
                isThreeLine: true,
                title: Text(audiols![i].name!),
                subtitle: Text(audiols![i].duration!),
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo.shade900,
                  child: const Icon(
                    FontAwesomeIcons.music,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/audio_player',
                    arguments: audiols![i],
                  );
                },
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}
