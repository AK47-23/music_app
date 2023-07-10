import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/ui/checkweb.dart';
import 'package:provider/provider.dart';

import '../../music/provider/music_provider.dart';
import '../../music/ui/music_player_mobile.dart';
import '../../utils/cs_text_style.dart';
import '../../utils/navigate.dart';

class AlbumWidgets{

  Widget musicList(List<TrackModel> tracksList){
    final NumberFormat formatter = NumberFormat("00");
    return  ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracksList.length,
      itemBuilder: (context, index) {
        TrackModel trackModel = tracksList[index];
        return ListTile(
          onTap: () {
            context
                .read<MusicProvider>()
                .getTrackDetail(trackModel.id!);
            normalNavigate(
              context,
              const MusicLayout(),
            );
          },
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                  color: Colors.grey, width: 0.1)),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '#${formatter.format(index + 1)}',
              style: normalText1,
            ),
          ),
          title: Text(
            trackModel.name!,
            style: normalText1,
          ),
          subtitle: Text(
            trackModel.artistName!,
            style: subTitle1,
          ),
        );
      },
    );
  }
}