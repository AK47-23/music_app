import 'package:flutter/material.dart';
import 'package:music_app/album/repository/album_repo.dart';
import 'package:music_app/home/model/track_model.dart';

class AlbumProvider extends ChangeNotifier {
  final AlbumRepo _albumRepo = AlbumRepo();
  List<TrackModel> tracksList = [];

  bool isLoading = true;

  void getAlbumTracks(String albumId) async {
    tracksList = await _albumRepo.getAlbumTracks(albumId);
    isLoading = false;
    notifyListeners();
  }
}
