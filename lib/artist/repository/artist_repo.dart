import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/utils/common.dart';

class ArtistRepo {
  Future<ArtistModel> getArtistDetail(String id) async {
    ArtistModel artistModel = ArtistModel('', '', '', '');
    String artistUrl = "${Common.baseUrl}/artists/$id?apikey=${Common.apiKey}";

    try {
      var response = await Dio().get(artistUrl);
      artistModel = ArtistModel.fromMap(response.data["artists"][0]);
    } catch (e) {
      log(e.toString());
    }

    return artistModel;
  }

  Future<String> provideAritstImageUrlR(String id) async {
    String imageUrl = "";

    String url =
        "https://api.napster.com/v2.2/artists/$id/images?apikey=${Common.apiKey}";
    try {
      var response = await Dio().get(url);
      imageUrl = response.data["images"][0]["url"];
    } catch (e) {
      log(e.toString());
    }
    return imageUrl;
  }

  Future<List<AlbumModel>> getTopArtistAlbumsList(String id) async {
    List<AlbumModel> albumList = [];

    String albumUrl =
        "${Common.baseUrl}/artists/$id/albums/top?apikey=${Common.apiKey}&limit=5?";

    try {
      var response = await Dio().get(albumUrl);
      for (Map<String, dynamic> map in response.data["albums"]) {
        AlbumModel albumModel = AlbumModel.fromMap(map);
        albumList.add(albumModel);
      }
    } catch (e) {
      log(e.toString());
    }

    return albumList;
  }

  Future<List<AlbumModel>> getNewArtistAlbumsList(String id) async {
    List<AlbumModel> albumList = [];

    String albumUrl =
        "${Common.baseUrl}/artists/$id/albums/new?apikey=${Common.apiKey}&limit=5?";

    try {
      var response = await Dio().get(albumUrl);
      for (Map<String, dynamic> map in response.data["albums"]) {
        AlbumModel albumModel = AlbumModel.fromMap(map);
        albumList.add(albumModel);
      }
    } catch (e) {
      log(e.toString());
    }

    return albumList;
  }
}
