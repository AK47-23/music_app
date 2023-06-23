import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_app/home/model/track_model.dart';
import 'package:music_app/utils/common.dart';

class MusicRepo {
  Future<TrackModel> getTrackDetails(String trackId) async {
    TrackModel trackModel = TrackModel('', '', '', '', '', '');

    final trackUrl = "${Common.baseUrl}tracks/$trackId?apikey=${Common.apiKey}";

    try {
      var response = await Dio().get(trackUrl);

      if (response.statusCode == 200) {
        trackModel = TrackModel.fromMap(response.data['tracks'][0]);
      }
    } catch (e) {
      log(e.toString());
    }
    return trackModel;
  }
}
