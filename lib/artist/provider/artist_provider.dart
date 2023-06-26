import 'package:flutter/material.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/repository/artist_repo.dart';

class ArtistProvider extends ChangeNotifier {
  final ArtistRepo _artistRepo = ArtistRepo();

  bool isArtistLoading = true;
  ArtistModel artistModel = ArtistModel('', '', '', '');

  void getArtistDetail(String id) async {
    artistModel = await _artistRepo.getArtistDetail(id);
    provideAritstImageUrl(id);
  }

  void provideAritstImageUrl(String id) async {
    artistModel.image = await _artistRepo.provideAritstImageUrl(id);
    isArtistLoading = false;
    notifyListeners();
  }
}
