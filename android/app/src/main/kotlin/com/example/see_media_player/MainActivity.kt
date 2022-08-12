package com.example.see_media_player


import android.content.ContentResolver
import android.database.Cursor

import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import androidx.core.view.WindowCompat

import androidx.lifecycle.lifecycleScope


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import kotlinx.coroutines.launch


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }


        super.onCreate(savedInstanceState)
    }

    private var methodResult: MethodChannel.Result? = null
    override fun provideSplashScreen(): SplashScreen? = SplashView()

    private fun getCursor(URIs: Uri): Cursor? {
        //1
        val uri = URIs
        val projection: Array<String> = arrayOf(
            MediaStore.Video.Media.DATA,
            MediaStore.Video.Media.SIZE,
            MediaStore.Video.Media.DATE_MODIFIED,
            MediaStore.Video.Media.DATE_ADDED,
            MediaStore.Video.Media.WIDTH,
            MediaStore.Video.Media.HEIGHT,
            MediaStore.Video.Media.RESOLUTION,
            MediaStore.Video.Media.DURATION,
            MediaStore.Video.Media.BITRATE
        )

        //2
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            // val sort = "${MediaStore.Images.ImageColumns.DATE_MODIFIED} DESC LIMIT 1"
            val sort = MediaStore.Video.VideoColumns.DATE_MODIFIED
            contentResolver.query(uri, projection, null, null, sort)
        } else {
            //3
            val args = Bundle().apply {

                putStringArray(
                    ContentResolver.QUERY_ARG_SORT_COLUMNS,
                    arrayOf(MediaStore.Video.VideoColumns.DATE_MODIFIED)
                )
                putInt(
                    ContentResolver.QUERY_ARG_SORT_DIRECTION,
                    ContentResolver.QUERY_SORT_DIRECTION_DESCENDING
                )
            }
            contentResolver.query(uri, projection, args, null)
        }
    }


    // End
    private fun getCursorAudio(URIs: Uri): Cursor? {
        //1
        val uri = URIs
        val projection: Array<String> = arrayOf(
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.DATE_MODIFIED,
            MediaStore.Audio.Media.DATE_ADDED,
            MediaStore.Audio.Media.WIDTH,
            MediaStore.Audio.Media.HEIGHT,
            MediaStore.Audio.Media.RESOLUTION,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.BITRATE
        )

        //2
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            // val sort = "${MediaStore.Images.ImageColumns.DATE_MODIFIED} DESC LIMIT 1"
            val sort = MediaStore.Audio.AudioColumns.DATE_MODIFIED
            contentResolver.query(uri, projection, null, null, sort)
        } else {
            //3
            val args = Bundle().apply {

                putStringArray(
                    ContentResolver.QUERY_ARG_SORT_COLUMNS,
                    arrayOf(MediaStore.Audio.AudioColumns.DATE_MODIFIED)
                )
                putInt(
                    ContentResolver.QUERY_ARG_SORT_DIRECTION,
                    ContentResolver.QUERY_SORT_DIRECTION_DESCENDING
                )
            }
            contentResolver.query(uri, projection, args, null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)


        val messenger = flutterEngine.dartExecutor.binaryMessenger

        //audio channel
        MethodChannel(
            messenger,
            "getExternalAudios",


            ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAudio" -> {
                    methodResult = result;
                    getAllAudios();
                }

                else -> result.notImplemented()

            }
        }
        //video channel
        MethodChannel(
            messenger,
            "getExternalVideos",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getVideos" -> {
                    methodResult = result
                    getAllVideos()
                }
                "getVideoThumbnail" -> {
                    methodResult = result
                    val path = call.arguments<String>()
                    getThumbnail(path)

                }
                "getAudio" -> {
                    methodResult = result;
                    getAllAudios();
                }

                else -> result.notImplemented()
            }
        }
    }


private  fun  getThumbnail(path:String?){
var thumb=   FlutterChanels().buildThumbnailData(path);
    methodResult?.success(thumb)
}

    private fun getAllVideos() {

        lifecycleScope.launch {
            val ids = mutableListOf<Map<String, Any>>()
            val cursorExternal = getCursor(MediaStore.Video.Media.EXTERNAL_CONTENT_URI)
            val cursorInternal = getCursor(MediaStore.Video.Media.INTERNAL_CONTENT_URI)

            ids.addAll(FlutterChanels().cursorWalker(cursorExternal));
            ids.addAll(FlutterChanels().cursorWalker(cursorInternal));

            methodResult?.success(ids)
        }

    }

    private fun getAllAudios() {
        lifecycleScope.launch {

            val ids = mutableListOf<Map<String, Any>>()
            val cursorExternal = getCursorAudio(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI)
            val cursorInternal = getCursorAudio(MediaStore.Audio.Media.INTERNAL_CONTENT_URI)

            ids.addAll(FlutterChanels().cursorWalkerAudio(cursorExternal));
            ids.addAll(FlutterChanels().cursorWalkerAudio(cursorInternal));

            methodResult?.success(ids)
        }
    }

}
