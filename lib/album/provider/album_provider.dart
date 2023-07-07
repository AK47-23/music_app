import 'package:flutter/material.dart';
import 'package:music_app/album/repository/album_repo.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../utils/common.dart';

class AlbumProvider extends ChangeNotifier {
  final AlbumRepo _albumRepo = AlbumRepo();
  List<TrackModel> tracksList = [];
  PaletteColor colors= PaletteColor(const Color(0xffffe5b4), 2);

  bool isLoading = true;

  void getAlbumTracks(String albumId) async {
    isLoading = true;
    notifyListeners();
    tracksList = await _albumRepo.getAlbumTracks(albumId);
    colors = await Common.updatePalette(albumId, true);
    isLoading = false;
    notifyListeners();
  }


}
