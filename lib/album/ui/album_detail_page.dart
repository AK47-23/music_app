import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail_page.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AlbumDetailPage extends StatelessWidget {
  AlbumDetailPage({super.key});

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
        ? Common().loadingIndicator(context)
        : Consumer<AlbumProvider>(builder: (context, value, widget) {
            List<TrackModel> tracksList = value.tracksList;
            return tracksList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight * .01,
                        ),
                        Common().makeImageResource(
                            tracksList[0].albumId!, "albums", .3, .25),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                child: Icon(
                                  Icons.person,
                                  size: 15.sp,
                                ),
                              ),
                              SizedBox(width: 15.sp),
                              Text(
                                tracksList[0].artistName!,
                                style: normalText1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.sp),
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
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'Something went wrong!',
                      style: titleText2,
                    ),
                  );
          });
  }
}
