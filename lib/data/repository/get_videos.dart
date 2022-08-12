import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetAllVideos {
  final methodChannel = const MethodChannel('getExternalVideos');
  Future<List<Map>> getAllVideos() async {
    try {
      final results = await methodChannel.invokeMethod<List>(
        'getVideos',
      );

      if (results != null && results.isNotEmpty) {
        return results.cast<Map>();
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
