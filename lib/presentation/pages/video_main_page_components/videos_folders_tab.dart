import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:see_media_player/data/models/video_information.dart';

import '../../../business_logic/providers/logic/videos_folder_provider.dart';

class VideosFoldersTab extends StatefulWidget {
  const VideosFoldersTab({Key? key}) : super(key: key);

  @override
  State<VideosFoldersTab> createState() => _VideosFoldersTabState();
}

class _VideosFoldersTabState extends State<VideosFoldersTab> {
  Map<String, List<VideoInformation>> videos = {};
  @override
  void initState() {
    super.initState();
    context.read<VideosFolderProvider>().getVideosFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    videos = context.watch<VideosFolderProvider>().videos!;
    return RefreshIndicator(
      onRefresh: () =>
          context.read<VideosFolderProvider>().getVideosFromDevice(),
      child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemBuilder: (_, i) {
              return ExpansionTile(
                title: Text(
                  videos.keys.toList()[i],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  videos.values.toList()[i].length.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(
                  Icons.folder,
                  color: Colors.black87,
                  size: 45,
                ),
                children: videos[videos.keys.toList()[i]]!.toList().map((e) {
                  // print(e.path);

                  return ListTile(
                    title: Text(
                      e.name!,
                    ),
                    subtitle: Text(
                      e.duration!,
                    ),
                    leading: const Icon(
                      Icons.video_library,
                      color: Colors.black87,
                      size: 45,
                    ),
                    onTap: () async {
                      await Navigator.of(context).pushNamed(
                        '/video_player',
                        arguments: e,
                      );
                    },
                  );
                }).toList(),
              );
            },
            itemCount: videos.keys.length,
          )),
    );
  }
}
