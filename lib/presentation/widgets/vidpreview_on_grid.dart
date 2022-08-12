import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/business_logic/providers/logic/video_preview_provider.dart';
import 'package:see_media_player/data/models/video_information.dart';

class VidPreviewOnGrid extends StatefulWidget {
  const VidPreviewOnGrid({Key? key, this.video}) : super(key: key);
  final VideoInformation? video;

  @override
  State<VidPreviewOnGrid> createState() => _VidPreviewOnGridState();
}

class _VidPreviewOnGridState extends State<VidPreviewOnGrid> {
  @override
  void initState() {
    super.initState();
    Provider.of<VideoPreviewProvider>(context, listen: false).setImagePyPath();
  }

  @override
  Widget build(BuildContext context) {
    var image = Provider.of<VideoPreviewProvider>(context).image;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/video_player',
          arguments: widget.video,
        );
      },
      child: Stack(
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.white10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: image!.isNotEmpty
                      ? MemoryImage(image)
                      : Image.asset('assets/img/erorr.png').image,
                  fit: BoxFit.cover,
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Chip(
              label: Text(
                widget.video!.duration ?? 'No Name',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
