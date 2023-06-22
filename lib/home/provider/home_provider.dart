import 'package:flutter/material.dart';
import 'package:music_app/home/model/album_model.dart';
import 'package:music_app/home/model/track_model.dart';
import 'package:music_app/home/repository/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  final _homeRepo = HomeRepo();

  List<TrackModel> tracksList = [];
  List<AlbumModel> albumList = [];

  bool isTrackLoading = true;
  bool isAlbumLoading = true;

  void getTopTracks(int limit) async {
    tracksList = await _homeRepo.getTopTracks(limit.toString());
    isTrackLoading = false;
    notifyListeners();
  }

  void getTopAlbums(int limit) async {
    albumList = await _homeRepo.getTopAlbums(limit.toString());
    isAlbumLoading = false;
    notifyListeners();
  }
}
