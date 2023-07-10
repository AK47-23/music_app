import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/widgets/artist_widgets.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ArtistDetailMobile extends StatelessWidget {
  const ArtistDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    return context.watch<ArtistProvider>().isArtistLoading
        ? Common.loadingIndicator(context)
        : SafeArea(

          child: SingleChildScrollView(
              child: Consumer<ArtistProvider>(builder: (context, value, widget) {
                ArtistModel artistModel = value.artistModel;
                log(artistModel.image!.toString());
                return SizedBox(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * .02,
                      ),
                     Common.makeCustomAppbar('ARTIST DETAIL', context),
                      Common
                          .makeImageResource(artistModel.id!, "artists", .3, .25),
                      SizedBox(
                        height: SizeConfig.screenHeight * .03,
                      ),
                      Text(
                        artistModel.name!,
                        style: titleText1,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ReadMoreText(
                          artistModel.bio!,
                          trimLines: 3,
                          style: subTitle1,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                        ArtistWidget.artistTiles(context, value.topList, value.newList),
                    ],
                  ),
                );
              }),
            ),
        );
  }

  buildCategoryTitle(String title) {
    return Text(
      title,
      style: titleText2,
    );
  }

  Widget buildCustomAlbumList(List<AlbumModel> albumList) {
    return SizedBox(
      height: SizeConfig.screenHeight * .25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            AlbumModel albumModel = albumList[index];
            return Common.mainTile(context, albumModel.albumId!,
                albumModel.albumId!, albumModel.albumName!, "albums");
          }),
    );
  }
}
