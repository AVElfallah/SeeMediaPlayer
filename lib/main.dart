import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/business_logic/providers/logic/all_audios_provider.dart';
import 'package:see_media_player/business_logic/providers/logic/audio_displayer_provider.dart';
import 'package:see_media_player/business_logic/providers/logic/video_displayer_provider.dart';
import 'package:see_media_player/presentation/pages/audio_main_page.dart';
import 'package:see_media_player/presentation/pages/video_player.dart';

import 'presentation/pages/audio_player.dart';
import 'presentation/pages/video_main_page.dart';

import '../../presentation/pages/error_page.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player',
      routes: {
        '/': (context) => const VideoMainPage(),
        '/audio': (context) => ChangeNotifierProvider<AllAudiosProvider>(
              create: (_) => AllAudiosProvider(),
              child: const AudioMainPage(),
            ),
        '/audio_player': (context) => ChangeNotifierProvider(
              lazy: true,
              create: (_) => AudioDisplayerProvider(),
              child: const AudioDisplayerPage(),
            ),
        '/video_player': (_) => ChangeNotifierProvider<VideoDisplayerProvider>(
            lazy: true,
            create: (_) => VideoDisplayerProvider(),
            child: const VideoDisplayerPage()),
        '/error': (context) => const ErrorPage(),
      },
      initialRoute: '/',
      onUnknownRoute: (st) {
        return MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
      },
    );
  }
}
