import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/utils/common.dart';

class HomeRepo {
  Future<List<TrackModel>> getTopTracks(String limit) async {
    final topTrackUrl =
        "${Common.baseUrl}tracks/top?apikey=${Common.apiKey}&limit=$limit";

    List<TrackModel> tracksList = [];
    try {
      var response = await Dio().get(
        topTrackUrl,
      );

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

  Future<List<AlbumModel>> getTopAlbums(String limit) async {
    final topAlbumUrl =
        "${Common.baseUrl}albums/top?apikey=${Common.apiKey}&limit=$limit";

    List<AlbumModel> albumList = [];
    try {
      var response = await Dio().get(
        topAlbumUrl,
      );

      if (response.statusCode == 200) {
        for (Map<String, dynamic> map in response.data["albums"]) {
          AlbumModel albumModel = AlbumModel.fromMap(map);
          albumList.add(albumModel);
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return albumList;
  }
}
