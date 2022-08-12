import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GetAllAudios {
  final methodChannel = const MethodChannel('getExternalAudios');
  Future<List<Map>> getAllAudios() async {
    try {
      final results = await methodChannel.invokeMethod<List>(
        'getAudio',
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
