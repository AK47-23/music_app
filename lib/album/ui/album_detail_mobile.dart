import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail_mobile.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/album_widgets.dart';

class AlbumDetailMobile extends StatelessWidget {
 const AlbumDetailMobile({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {

    return context.watch<AlbumProvider>().isLoading
        ? Common.loadingIndicator(context)
        : Consumer<AlbumProvider>(builder: (context, value, widget) {

            List<TrackModel> tracksList = value.tracksList;
            return tracksList.isNotEmpty
                ? SingleChildScrollView(
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              height: SizeConfig.screenHeight * .48,
                              width: SizeConfig.screenWidth,
                              decoration: BoxDecoration(gradient: LinearGradient(colors: [
                                value.colors.color,
                                Colors.black87,
                              ],begin:Alignment.topRight,end: Alignment.bottomLeft )),
                            )),
                        Column(
                          children: [
                                SizedBox(
                                  height: SizeConfig.screenHeight * .01,
                                ),
                            Common.makeCustomAppbar('ALBUM DETAIL', context),
                            SizedBox(
                              height: SizeConfig.screenHeight * .01,
                            ),
                                Common.makeImageResource(
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
                                      const ArtistDetailMobile(),
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
                                        style: subTitle1,
                                      ),
                                    ],
                                  ),
                                ),
                            SizedBox(height: 20.sp),
                            AlbumWidgets().musicList(tracksList),
                          ],
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
