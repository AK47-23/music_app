import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatelessWidget {
  AlbumDetail({super.key});

  final NumberFormat formatter = NumberFormat("00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Common().makeAppbar('ALBUM DETAIL'),
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    return context.watch<AlbumProvider>().isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<AlbumProvider>(builder: (context, value, widget) {
            List<TrackModel> tracksList = value.tracksList;
            return tracksList.isNotEmpty
                ?makeeBody(context, tracksList)
            // CustomScrollView(slivers: [
            //         SliverAppBar(
            //           floating: true,
            //           // centerTitle: true,
            //           expandedHeight: SizeConfig.screenHeight * .3,
            //           leadingWidth: 0,
            //           flexibleSpace: FlexibleSpaceBar(
            //             // centerTitle: true,
            //             // title: Text('ALBUM DETAIL',style:normalText1),
            //             background: Common().makeImageResource(
            //                 tracksList[0].albumId!, "albums", .3, .3),
            //           ),
            //         ),
            //         SliverToBoxAdapter(
            //           child: Column(
            //             children: [
            //               Text(
            //                 tracksList[0].albumName!,
            //                 style: titleText1,
            //               ),
            //               InkWell(
            //                 onTap: () {
            //                   context
            //                       .read<ArtistProvider>()
            //                       .getArtistDetail(tracksList[0].artistId!);
            //                   normalNavigate(
            //                     context,
            //                     const ArtistDetailPage(),
            //                   );
            //                 },
            //                 child: Text(
            //                   tracksList[0].artistName!,
            //                   style: normalText1,
            //                 ),
            //               ),
            //               ListView.builder(
            //                 shrinkWrap: true,
            //                 physics: const NeverScrollableScrollPhysics(),
            //                 itemCount: tracksList.length,
            //                 itemBuilder: (context, index) {
            //                   TrackModel trackModel = tracksList[index];
            //                   return ListTile(
            //                     onTap: () {
            //                       context
            //                           .read<MusicProvider>()
            //                           .getTrackDetail(trackModel.id!);
            //                       normalNavigate(
            //                         context,
            //                         const MusicPlayer(),
            //                       );
            //                     },
            //                     shape: BeveledRectangleBorder(
            //                         borderRadius: BorderRadius.circular(0),
            //                         side: const BorderSide(
            //                             color: Colors.grey, width: 0.1)),
            //                     leading: Text(
            //                       '#${formatter.format(index + 1)}',
            //                       style: normalText1,
            //                     ),
            //                     title: Text(
            //                       trackModel.name!,
            //                       style: normalText1,
            //                     ),
            //                     subtitle: Text(
            //                       trackModel.artistName!,
            //                       style: subTitle1,
            //                     ),
            //                   );
            //                 },
            //               ),
            //             ],
            //           ),
            //         )
            //       ])
                : Center(
                    child: Text(
                      'Something went wrong!',
                      style: titleText2,
                    ),
                  );
          });
  }

  Widget makeeBody(BuildContext context, List<TrackModel> tracksList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Common().makeImageResource(tracksList[0].albumId!, "albums", .3, .25),
          Text(
            tracksList[0].albumName!,
            style: titleText1,
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              context
                  .read<ArtistProvider>()
                  .getArtistDetail(tracksList[0].artistId!);
              normalNavigate(
                context,
                const ArtistDetailPage(),
              );
            },
            child: Text(
              tracksList[0].artistName!,
              style: normalText1,
            ),
          ),
          ListView.builder(
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
                    const MusicPlayer(),
                  );
                },
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: const BorderSide(
                        color: Colors.grey, width: 0.1)),
                leading: Text(
                  '#${formatter.format(index + 1)}',
                  style: normalText1,
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
          ),
        ],
      ),
    );
  }
}
