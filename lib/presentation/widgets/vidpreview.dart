import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/data/models/video_information.dart';

import '../../business_logic/providers/logic/video_preview_provider.dart';

class VideoPreviewWidget extends StatefulWidget {
  const VideoPreviewWidget({
    Key? key,
    this.vid,
  }) : super(key: key);
  final VideoInformation? vid;

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoPreviewProvider>(context, listen: false).setImagePyPath();
    });

  }



  @override
  Widget build(BuildContext context) {
    
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Consumer<VideoPreviewProvider>(
      builder: (context, prov, child) {
        return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/video_player',
            arguments: widget.vid,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child:SizedBox(
            
            width: width,
            height:  height * 0.165,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        elevation: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          //video image
                          width: isLandScape ? width * .3 : width * 0.45,
                          height: isLandScape ? height * .5 : height * 0.17,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: prov.isImageLoaded
                                  ? FileImage(File(Provider.of<VideoPreviewProvider>(context).thumbnailImagePath!))
                                  : Image.asset('assets/img/erorr.png').image,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: height * 0.001,
                        right: width * 0.02,
                        child: Chip(
                          elevation: 0,
                          // backgroundColor: Colors.black.withOpacity(.6),
                          label: Text(
                            widget.vid!.duration.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isLandScape ? width * 0.02 : width * 0.03,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //video title widget
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: isLandScape ? width * .5 : width * 0.47,
                            child: Text(
                              widget.vid!.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: isLandScape ? 2 : 1,
                              style: TextStyle(
                                fontSize: isLandScape ? height * .03 : height * 0.017,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        //video quality widget.vid!
                        Flexible(
                          flex: 1,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  avatar: const Icon(
                                    FontAwesomeIcons.solidFileVideo,
                                    color: Colors.black54,
                                  ),
                                  label: Text(
                                    '${widget.vid!.quality!}P',
                                    maxLines: 1 ,
                                    overflow:
                                      TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                             
                                Chip(
                                  avatar: const Icon(
                                    FontAwesomeIcons.solidFile,
                                    color: Colors.black54,
                                  ),
                                  label: Text(
                                    '${widget.vid!.size!}MB',
                                    maxLines: 1,
                                    
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                          //video folder widget.vid!
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height:
                                  isLandScape ? height * .095 : height * 0.042,
                              color: Colors.grey.shade900,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.folderOpen,
                                    color: Colors.blue.shade600,
                                  ),
                                  Text(
                                    widget.vid!.fileName!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: isLandScape
                                          ? height * .05
                                          : height * 0.02,
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
