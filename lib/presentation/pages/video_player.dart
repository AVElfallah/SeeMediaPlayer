import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:better_player/better_player.dart';

import '../../business_logic/providers/logic/video_displayer_provider.dart';
import '../../data/models/video_information.dart';

class VideoDisplayerPage extends StatefulWidget {
  const VideoDisplayerPage({Key? key}) : super(key: key);

  @override
  State<VideoDisplayerPage> createState() => _VideoDisplayerState();
}

class _VideoDisplayerState extends State<VideoDisplayerPage> {
 late final VideoDisplayerProvider prov;
 late final VideoInformation args;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       args = ModalRoute.of(context)!.settings.arguments as VideoInformation;
       prov = context.read<VideoDisplayerProvider>();
      prov.initialize(args.path!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoDisplayerProvider>(
            builder: (context, provListen, child) {
              return provListen.isLoaded
          ? Center(
                  child: BetterPlayer(
                    controller: provListen.videoController,
                  ),
                ): const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
            }
          )
          ,
    );
  }
}
