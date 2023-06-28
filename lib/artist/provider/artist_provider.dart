import 'package:flutter/material.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/repository/artist_repo.dart';

class ArtistProvider extends ChangeNotifier {
  final ArtistRepo _artistRepo = ArtistRepo();

  bool isArtistLoading = true;
  ArtistModel artistModel = ArtistModel('', '', '', '');
  List<AlbumModel> topList = [];
  List<AlbumModel> newList = [];

  void getArtistDetail(String id) async {
    isArtistLoading = true;
    artistModel = await _artistRepo.getArtistDetail(id);

    if (artistModel.name != '') {
      getTopList(id);
      getNewList(id);
    }
  }

  void getTopList(String id) async {
    topList = await _artistRepo.getTopArtistAlbumsList(id);
    notifyListeners();
  }

  void getNewList(String id) async {
    newList = await _artistRepo.getNewArtistAlbumsList(id);
    isArtistLoading = false;
    notifyListeners();
  }
}
