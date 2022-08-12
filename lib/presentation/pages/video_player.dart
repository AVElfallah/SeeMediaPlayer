import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:better_player/better_player.dart';

import '../../business_logic/providers/logic/video_displayer_provider.dart';
import '../../data/models/video_information.dart';

class VideoDisplayerPage extends StatefulWidget {
  const VideoDisplayerPage({Key? key}) : super(key: key);

  @override
  State<VideoDisplayerPage> createState() => _VideoDisplayerState();
}

class _VideoDisplayerState extends State<VideoDisplayerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as VideoInformation;
    final provDo = context.read<VideoDisplayerProvider>();
    final provListen = context.watch<VideoDisplayerProvider>();
    provDo.initialize(args.path!);

    return Scaffold(
      backgroundColor: Colors.black,
      body: provListen.isIntialized
          ? Center(
              child: BetterPlayer(
                controller: provListen.videoController,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            ),
    );
  }
}
