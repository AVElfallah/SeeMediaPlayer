import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/business_logic/providers/logic/all_videos_provider.dart';
import 'package:see_media_player/business_logic/providers/logic/videos_folder_provider.dart';

import 'video_main_page_components/all_videos_tab.dart';
import 'video_main_page_components/videos_folders_tab.dart';

class VideoMainPage extends StatefulWidget {
  const VideoMainPage({Key? key}) : super(key: key);

  @override
  State<VideoMainPage> createState() => _VideoMainPageState();
}

class _VideoMainPageState extends State<VideoMainPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
                Radius.circular(
                  25,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red.shade700,
                  ),
                  highlightColor: Colors.red,
                  splashColor: Colors.amber,
                  splashRadius: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/audio');
                  },
                  icon: const Icon(
                    FontAwesomeIcons.music,
                    color: Colors.white,
                  ),
                  highlightColor: Colors.red,
                  splashColor: Colors.amber,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Videos',
              icon: Icon(FontAwesomeIcons.cameraRetro),
            ),
            Tab(
              text: 'Folders',
              icon: Icon(FontAwesomeIcons.folder),
            ),
          ],
          indicatorColor: Colors.indigo.shade900,
          indicatorWeight: 2,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChangeNotifierProvider<AllVideosProvider>(
            create: (_) => AllVideosProvider(),
            lazy: true,
            child: const AllVideosTab(),
          ),
          ChangeNotifierProvider<VideosFolderProvider>(
            create: (_) => VideosFolderProvider(),
            lazy: true,
            child: const VideosFoldersTab(),
          ),
        ],
      ),
    );
  }
}
