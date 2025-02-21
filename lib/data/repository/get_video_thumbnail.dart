import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetVideoThumbnail {
  final methodChannel = const MethodChannel('getExternalVideos');

  Future<Uint8List> getThumbnail(String path) async {
    try {
      final results = await methodChannel.invokeMethod<Uint8List>(
        'getVideoThumbnail',
        path,
      );

      return results!;
    } catch (e) {
      debugPrint(e.toString());
      return Uint8List(0);
    }
  }
}
