import 'package:flutter/material.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/repository/music_repo.dart';

class MusicProvider extends ChangeNotifier {
  final musicRepo = MusicRepo();

  TrackModel trackModel = TrackModel('', '', '', '', '', '', '');
  bool isLoading = true;

  void getTrackDetail(String trackId) async {
    trackModel = await musicRepo.getTrackDetails(trackId);
    isLoading = false;
    notifyListeners();
  }
}
