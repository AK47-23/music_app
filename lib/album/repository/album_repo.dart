import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_app/home/model/track_model.dart';
import 'package:music_app/utils/common.dart';

class AlbumRepo {
  Future<List<TrackModel>> getAlbumTracks(String albumId) async {
    log(albumId.toString());
    List<TrackModel> tracksList = [];
    String albumDetailurl =
        "${Common.baseUrl}/albums/$albumId/tracks?apikey=${Common.apiKey}";

    try {
      var response = await Dio().get(
        albumDetailurl,
      );

      log(response.data.toString());

      if (response.statusCode == 200) {
        for (Map<String, dynamic> map in response.data["tracks"]) {
          TrackModel trackModel = TrackModel.fromMap(map);
          tracksList.add(trackModel);
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return tracksList;
  }
}
