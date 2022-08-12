package com.example.see_media_player


import android.database.Cursor
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.os.Build
import android.provider.MediaStore
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

public class FlutterChanels {


    public fun cursorWalker(cursor: Cursor?): List<Map<String, Any>> {
        val back = mutableListOf<Map<String, Any>>()


        cursor?.use {
            while (cursor.moveToNext()) {
                val path =
                    cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA)
                val date = cursor.getColumnIndex(MediaStore.Video.Media.DATE_MODIFIED)
                val size = cursor.getColumnIndex(MediaStore.Video.Media.SIZE)
                val duration = cursor.getColumnIndex(MediaStore.Video.Media.DURATION)
                val bitrate = cursor.getColumnIndex(MediaStore.Video.Media.BITRATE)
                val heigh = cursor.getColumnIndex(MediaStore.Video.Media.HEIGHT)
                val width = cursor.getColumnIndex(MediaStore.Video.Media.WIDTH)
                val resolution = cursor.getColumnIndex(MediaStore.Video.Media.RESOLUTION)
                val add_date = cursor.getColumnIndex(MediaStore.Video.Media.DATE_ADDED)

                val outputMap = mutableMapOf<String, Any>();
//get Duration as String in HH:MM:SS format or in MM:SS format if less than one hour
                var _backDuration: String;

                val _Minutes = TimeUnit.MILLISECONDS.toMinutes(cursor.getLong(duration));
                val _Seconds = TimeUnit.MILLISECONDS.toSeconds(cursor.getLong(duration));
//to set duration value in backDuration variable
                if (_Minutes / 60 > 0) {
                    _backDuration = (_Minutes / 60).toString()
                        .padStart(2, '0') + ":" + (_Minutes % 60).toString()
                        .padStart(2, '0') + ":" + (_Seconds % 60).toString().padStart(2, '0');
                } else {
                    _backDuration = (_Minutes % 60).toString()
                        .padStart(2, '0') + ":" + (_Seconds % 60).toString().padStart(2, '0');
                }
//get Size in MB with 2 decimal places
                val _Size = String.format("%.2f", (cursor.getLong(size).toDouble() / 1024 / 1024));

// get data as Strings
                val simpleDateFormat = SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.ENGLISH)
                fun getDateString(time: Long): String = simpleDateFormat.format(time * 1000L)
                val _Date = getDateString(cursor.getLong(date))
                val _Add_Date = getDateString(cursor.getLong(add_date))



                outputMap["path"] = cursor.getString(path)
                outputMap["date"] = _Date
                outputMap["date_add"] = _Add_Date
                outputMap["duration"] = _backDuration
                outputMap["size"] = _Size
                outputMap["heigh"] = cursor.getInt(heigh)
                outputMap["width"] = cursor.getInt(width)
                outputMap["resolution"] = cursor.getInt(resolution)
                outputMap["bitrate"] = cursor.getInt(bitrate)
                //  createAndSaveThumbnail(path.toString())
                // outputMap["thumbnail"] = path.toString().split('/').last()


                back.add(outputMap)
            }

        }
        return back;
    }


    public fun cursorWalkerAudio(cursor: Cursor?): List<Map<String, Any>> {
        val back = mutableListOf<Map<String, Any>>()


        cursor?.use {
            while (cursor.moveToNext()) {
                val path =
                    cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
                val date = cursor.getColumnIndex(MediaStore.Audio.Media.DATE_MODIFIED)
                val size = cursor.getColumnIndex(MediaStore.Audio.Media.SIZE)
                val duration = cursor.getColumnIndex(MediaStore.Audio.Media.DURATION)
                val bitrate = cursor.getColumnIndex(MediaStore.Audio.Media.BITRATE)
                val heigh = cursor.getColumnIndex(MediaStore.Audio.Media.HEIGHT)
                val width = cursor.getColumnIndex(MediaStore.Audio.Media.WIDTH)
                val resolution = cursor.getColumnIndex(MediaStore.Audio.Media.RESOLUTION)
                val add_date = cursor.getColumnIndex(MediaStore.Audio.Media.DATE_ADDED)

                val outputMap = mutableMapOf<String, Any>();
//get Duration as String in HH:MM:SS format or in MM:SS format if less than one hour
                var _backDuration: String;

                val _Minutes = TimeUnit.MILLISECONDS.toMinutes(cursor.getLong(duration));
                val _Seconds = TimeUnit.MILLISECONDS.toSeconds(cursor.getLong(duration));
//to set duration value in backDuration variable
                if (_Minutes / 60 > 0) {
                    _backDuration = (_Minutes / 60).toString()
                        .padStart(2, '0') + ":" + (_Minutes % 60).toString()
                        .padStart(2, '0') + ":" + (_Seconds % 60).toString().padStart(2, '0');
                } else {
                    _backDuration = (_Minutes % 60).toString()
                        .padStart(2, '0') + ":" + (_Seconds % 60).toString().padStart(2, '0');
                }
//get Size in MB with 2 decimal places
                val _Size = String.format("%.2f", (cursor.getLong(size).toDouble() / 1024 / 1024));

// get data as Strings
                val simpleDateFormat = SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.ENGLISH)
                fun getDateString(time: Long): String = simpleDateFormat.format(time * 1000L)
                val _Date = getDateString(cursor.getLong(date))
                val _Add_Date = getDateString(cursor.getLong(add_date))



                outputMap["path"] = cursor.getString(path)
                outputMap["date"] = _Date
                outputMap["date_add"] = _Add_Date
                outputMap["duration"] = _backDuration
                outputMap["size"] = _Size
                outputMap["heigh"] = cursor.getInt(heigh)
                outputMap["width"] = cursor.getInt(width)
                outputMap["resolution"] = cursor.getInt(resolution)
                outputMap["bitrate"] = cursor.getInt(bitrate)
                //  createAndSaveThumbnail(path.toString())
                // outputMap["thumbnail"] = path.toString().split('/').last()


                back.add(outputMap)
            }

        }
        return back;

    }


    private fun createVideoThumbnail(
        video: String?
    ): Bitmap? {
        val targetH = 512
        val targetW = 512

        var bitmap: Bitmap? = null
        val retriever = MediaMetadataRetriever()
        retriever.setDataSource(video)

        val time = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
        val timeMs  = if(time!!.toLong()>2000) time.toLong()/2 else time.toLong();
        try {

            if (Build.VERSION.SDK_INT >= 27 ) {
                // API Level 27
                bitmap = retriever
                    .getScaledFrameAtTime(
                        (timeMs).toLong(), MediaMetadataRetriever.OPTION_CLOSEST,
                        targetW, targetH
                    )
            } else {
                bitmap = retriever.getFrameAtTime(
                    (timeMs).toLong(),
                    MediaMetadataRetriever.OPTION_CLOSEST
                )

            }

        } catch (ex: IllegalArgumentException) {
            ex.printStackTrace()
        } catch (ex: RuntimeException) {
            ex.printStackTrace()
        } catch (ex: IOException) {
            ex.printStackTrace()
        } finally {
            try {
                retriever.release()
            } catch (ex: RuntimeException) {
                ex.printStackTrace()
            }
        }
        return bitmap
    }

    public fun buildThumbnailData(
        vidPath: String?
    ): ByteArray? {

        val bitmap = createVideoThumbnail(vidPath)
            ?: throw NullPointerException()
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 75, stream)
        bitmap.recycle()
        if (bitmap == null) throw NullPointerException()
        return stream.toByteArray()
    }


}