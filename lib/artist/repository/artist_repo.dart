import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/utils/common.dart';

class ArtistRepo {
  Future<ArtistModel> getArtistDetail(String id) async {
    ArtistModel artistModel = ArtistModel('', '', '', '');

    String artistUrl = "${Common.baseUrl}/artists/$id?${Common.apiKey}";

    var response = await Dio().get(artistUrl);

    log(response.data["artists"].toString());
    artistModel = ArtistModel.fromMap(response.data["artists"][0]);
    return artistModel;
  }

  Future<String> provideAritstImageUrl(String id) async {
    String imageUrl = "";

    String url =
        "https://api.napster.com/imageserver/v2/artists/$id/images?apikey=${Common.apiKey}";
    var response = await Dio().get(url);

    imageUrl = response.data["images"][0][url];
    return imageUrl;
  }

  Future<List<AlbumModel>> getTopArtistAlbumsList(String id) async {
    List<AlbumModel> albumList = [];

    String albumUrl =
        "${Common.baseUrl}/artists/$id/albums/top?${Common.apiKey}&limit=5?";

    var response = await Dio().get(albumUrl);
    log(response.data["albums"]);
    for (Map<String, dynamic> map in response.data["albums"]) {
      AlbumModel albumModel = AlbumModel.fromMap(map);
      albumList.add(albumModel);
    }
    return albumList;
  }
}
