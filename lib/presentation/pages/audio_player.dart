import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:see_media_player/business_logic/providers/logic/audio_displayer_provider.dart';
import 'package:see_media_player/data/models/audio_information.dart';

class AudioDisplayerPage extends StatefulWidget {
  const AudioDisplayerPage({Key? key}) : super(key: key);

  @override
  State<AudioDisplayerPage> createState() => _AudioDisplayerPageState();
}

class _AudioDisplayerPageState extends State<AudioDisplayerPage>
    with TickerProviderStateMixin {

  late final AnimationController _animController ;
  late final Animation<double> _animation ;

  late AudioInformation args;

  late final AudioDisplayerProvider audioDisplayerProvider ;


  @override
  void initState() {

    super.initState();
    _animController =   AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve)
    ;

    _animation= CurvedAnimation(parent: _animController, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
       args = ModalRoute.of(context)?.settings.arguments
          as AudioInformation;
    audioDisplayerProvider =   context.read<AudioDisplayerProvider>()..initialControllers(args.path!);
     
    });

  }

  @override

  void dispose() {
audioDisplayerProvider.dispose();
    _animation.removeListener(() {});
    _animController.dispose();
        super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var isLandScape = MediaQuery.of(context).orientation ==
        Orientation.landscape; // isLandScape;
    final width = MediaQuery.of(context).size.width; // width of the screen
    final height = MediaQuery.of(context).size.height; //height of the screen

//list of controllers
    

//check if provider is initialized and then return the widget
    return  Consumer<AudioDisplayerProvider>(
      builder: (context, prov, child) {
        final listOfControlsButtons = [
      IconButton(
        onPressed: () {
          context.read<AudioDisplayerProvider>().seekBackward();
        },
        icon: const Icon(FontAwesomeIcons.backward),
      ),
      IconButton(
        onPressed: () {
          context.read<AudioDisplayerProvider>().playPauseAudio();
          if (prov.isPlaying) {
            _animController.repeat();
          } else {
            _animController.stop();
          }
        },
        icon: prov.isPlaying
            ? const Icon(FontAwesomeIcons.pause)
            : const Icon(FontAwesomeIcons.play),
      ),
      IconButton(
        onPressed: () {
          context.read<AudioDisplayerProvider>().seekForward();
        },
        icon: const Icon(FontAwesomeIcons.forward),
      )
    ];
        return prov.isInitialized
          ? 
           Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                // set title of the AppBar on landscape mode
                // and hide title on portrait mode
                title: isLandScape
                    ? Hero(
                        tag: 'audio_player_title',
                        child: Text(
                          '${args.name}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )
                    : const SizedBox.shrink() //make it empty
                ,
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.angleDown,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      prov.setLoopMode(LoopMode.all);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.repeat,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: SizedBox(
          
                height: height,
                width: width,
                child: Stack(
                  children: [
                    // in landscape mode the audio title is hidden
                    //so we use [isLandScape] to hide the title
                    !isLandScape
                        ? AnimatedPositioned(
                            duration: const Duration(milliseconds: 1400),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Hero(
                                tag: 'audio_player_title',
                                child: Text(
                                  '${args.name}',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox() //empty widget
                    ,
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 1400),
                      bottom: isLandScape ? height * .22 : height * .35,
                      left: isLandScape ? width * .35 : width * .11,
                      child: GestureDetector(
                        onTap: () async {
                          await context
                              .read<AudioDisplayerProvider>()
                              .playPauseAudio();
                          if (prov.isPlaying) {
                            _animController.repeat();
                          } else {
                            _animController.stop();
                          }
                        },
                        child: RotationTransition(
                          turns: _animation,
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/img/m_displayer.jpg'),
                              radius: isLandScape ? width * .129 : width * .40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<Duration>(
                        stream: prov.positionStream,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? AnimatedPositioned(
                                  bottom:
                                      isLandScape ? height * .086 : height * .21,
                                  left: isLandScape ? width * .09 : 0,
                                  duration: const Duration(milliseconds: 1400),
                                  child: SizedBox(
                                    width: isLandScape ? width * .75 : width,
                                    child: Column(
                                      children: [
                                        Slider.adaptive(
                                          value:
                                              snapshot.data!.inSeconds.toDouble(),
                                          min: 0,
                                          max: prov
                                             .durationInSeconds,
                                          inactiveColor: Colors.amber,
                                          activeColor: Colors.black,
                                          thumbColor: Colors.black,
                                          label:
                                              '${snapshot.data!.inSeconds.toDouble()}',
                                          onChanged: (v) {
                                            context
                                                .read<AudioDisplayerProvider>()
                                                .seekToSecond(v);
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${(snapshot.data!.inSeconds ~/ 60).toString().padLeft(
                                                    2,
                                                    '0',
                                                  )}:${(snapshot.data!.inSeconds % 60).toString().padLeft(
                                                    2,
                                                    '0',
                                                  )}'),
                                              Text('${(prov.durationInSeconds ~/ 60).toString().padLeft(
                                                    2,
                                                    '0',
                                                  )}:${(prov.durationInSeconds % 60).toString().padLeft(
                                                    2,
                                                    '0',
                                                  )}'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                    AnimatedPositioned(
                      bottom: isLandScape ? height * .1 : height * .12,
                      left: isLandScape ? width * .9 : width * .12,
                      duration: const Duration(milliseconds: 1400),
                      child: Container(
                        width: isLandScape ? width * .067 : width * .75,
                        height: isLandScape ? height * .667 : height * .065,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: isLandScape
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: listOfControlsButtons,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: listOfControlsButtons,
                              ),
                      ),
                    )
                  ],
                ),
              )):const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
      }
    )
       ;
  }
}
