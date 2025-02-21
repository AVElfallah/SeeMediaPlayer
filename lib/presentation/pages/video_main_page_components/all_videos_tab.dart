import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:see_media_player/business_logic/providers/logic/all_videos_provider.dart';
import 'package:see_media_player/business_logic/providers/logic/video_preview_provider.dart';

import 'package:see_media_player/data/models/video_information.dart';
import 'package:see_media_player/data/repository/video_sorting.dart';

import '../../widgets/vidpreview.dart';
import '../../widgets/vidpreview_on_grid.dart';

class AllVideosTab extends StatefulWidget {
  const AllVideosTab({Key? key}) : super(key: key);

  @override
  State<AllVideosTab> createState() => _AllVideosTabState();
}

class _AllVideosTabState extends State<AllVideosTab> {
  SortingType? listSortingType = SortingType.name;
  SortingOrder? listSortingOrder = SortingOrder.asc;

  @override
  void initState() {
    super.initState();
    Provider.of<AllVideosProvider>(
      context,
      listen: false,
    ).getVideosFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;



    return Consumer<AllVideosProvider>(
      builder: (context, prov, child) {
        return RefreshIndicator(
        onRefresh: () => Provider.of<AllVideosProvider>(
          context,
          listen: false,
        ).getVideosFromDevice(),
        child: SizedBox(
          width: double.infinity,
          //  height: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              SizedBox(
                height: isLandScape ? height * .065 : height * 0.05,
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
          
                        context.read<AllVideosProvider>().sortingVideoList(
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
          
                        context.read<AllVideosProvider>().sortingVideoList(
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
                    IconButton(
                      onPressed: () {
                        prov.changeListState();
                      },
                      icon: Icon(
                        prov.isAList ? Icons.grid_view : FontAwesomeIcons.list,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 12,
              ),
              SizedBox(
                height: isLandScape ? height * 0.49 : height * 0.74,
                child:/* prov.isAList
                    ? ReorderableList(
                        cacheExtent: height * 2.55,
                        shrinkWrap: true,
                        itemCount: videos!.length,
                        itemBuilder: (context, index) {
                          var duration = videos![index].duration;
                          videos![index].duration =
                              duration == '00:00' ? '0:01' : duration;
          
                          return ChangeNotifierProvider<VideoPreviewProvider>(
                            key: ValueKey(videos![index].path),
                            create: (_) =>
                                VideoPreviewProvider(path: videos![index].path),
                            child: VideoPreviewWidget(
                              vid: videos![index],
                            ),
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {},
                      )
                    : */ ReorderableGridView.builder(
                        cacheExtent: isLandScape ? height * 1.5 : height * 2.55,
                        padding: const EdgeInsets.all(
                          20,
                        ),
                        itemCount:prov. videos.isEmpty?1:prov. videos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:prov.isAList?
                         (isLandScape?2: 1): ( isLandScape ? 3 : 2 ),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio:prov.isAList? 2:(isLandScape ? 1.52 : .66),
                        ),
                        itemBuilder: (_, i) {
                          return
                         prov. videos.isEmpty?
                       const   Text('No Videos Found',key: ValueKey('No Videos Found'),)
                          :
                           ChangeNotifierProvider<VideoPreviewProvider>(
                          create: (_) => VideoPreviewProvider(
                            path: prov.videos[i].path,
                          ),
                          key: ValueKey(prov.videos[i].path),
                          child:
                          prov.isAList
                              ? VideoPreviewWidget(
                                  vid:prov. videos[i],
                                )
                              :
                           VidPreviewOnGrid(
                            video:prov. videos[i],
                          ),
                        );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          // Reorder items
                        },
                      ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}
