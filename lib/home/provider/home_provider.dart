import 'package:flutter/material.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/home/repository/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  final _homeRepo = HomeRepo();

  List<TrackModel> tracksList = [];
  List<AlbumModel> albumList = [];
  List<ArtistModel> artistsList= [];

  bool isTrackLoading = true;
  bool isAlbumLoading = true;
  bool isArtistLoading=true;

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

  void getTopArtists(int limit)async{
    artistsList= await _homeRepo.getTopArtists(limit.toString());
    isArtistLoading=false;
    notifyListeners();
  }
}
