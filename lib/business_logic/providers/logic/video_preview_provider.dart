
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:see_media_player/data/repository/get_video_thumbnail.dart';
import 'package:see_media_player/data/repository/image_service.dart';
import 'package:see_media_player/data/repository/storage_service.dart';

class VideoPreviewProvider extends ChangeNotifier {
  VideoPreviewProvider({this.path});
  late final String? path;

  late String? thumbnailImagePath = '';

  bool isImageLoaded = false;

/*   Future<void> setImagePyPath() async {
    image = await compute<String, Uint8List>((m) async {
      return await GetVideoThumbnail().getThumbnail(path??"");
    }, path!);
    isImageLoaded = true;
    notifyListeners();
  } */

  Future<void> setImagePyPath() async {
    try {
      if (path == null) {
        isImageLoaded = false;
        thumbnailImagePath = '';
        notifyListeners();
        return;
      }
      final isInLocalStorage =
          await LocalStorageService.instance.checkIfThumbnailExists(path!);
      if (isInLocalStorage ) {
        thumbnailImagePath =
            LocalStorageService.instance.getCustomVideoThumbnail(path!);

        isImageLoaded = true;
        notifyListeners();
        return;
      } else {
        final image = await GetVideoThumbnail().getThumbnail(path!);

        thumbnailImagePath = await ImageService().createAThumbnail(image);

        isImageLoaded = true;
        LocalStorageService.instance.writeCustomVideoThumbnail(
          path!,
          thumbnailImagePath!,
        );
        notifyListeners();
      }
    } 
    on ProviderNullException catch(e) {
      debugPrint('ProviderNullException: $e');
    }
    catch (e, s) {
          debugPrint('Error generating thumbnail with compute: $e');
      debugPrint('Stack trace: $s');
      isImageLoaded = false;
      thumbnailImagePath = '';
      notifyListeners();

  
    }
  }

  @override
  void dispose() {
    debugPrint('VideoPreviewProvider disposed');
    super.dispose();
  }
}
