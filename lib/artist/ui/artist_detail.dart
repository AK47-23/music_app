import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/album/ui/album_detail.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class ArtistDetailPage extends StatelessWidget {
  const ArtistDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: Common().makeAppbar('ARTIST DETAIL'),
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    return context.watch<ArtistProvider>().isArtistLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Consumer<ArtistProvider>(builder: (context, value, widget) {
              ArtistModel artistModel = value.artistModel;
              log(artistModel.image!.toString());
              return SizedBox(
                width: SizeConfig.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * .04,
                    ),
                    Common().makeImageResource(
                        artistModel.id!, "artists", .3, .25),
                    SizedBox(
                      height: SizeConfig.screenHeight * .03,
                    ),
                    Text(
                      artistModel.name!,
                      style: titleText1,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      height: SizeConfig.screenHeight * .1,
                      child: Text(
                        artistModel.bio!,
                        style: subTitle1,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * .02,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10,bottom:10, right:0,left: 15),
                      width: SizeConfig.screenWidth,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCategoryTitle('TOP'),
                          buildCustomAlbumList(value.topList),
                          buildCategoryTitle('NEW'),
                          buildCustomAlbumList(value.newList),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
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
            return InkWell(
              onTap: () {
                context
                    .read<AlbumProvider>()
                    .getAlbumTracks(albumModel.albumId!);
                normalNavigate(context, AlbumDetail());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                width: SizeConfig.screenWidth * .4,
                child: Stack(
                  children: [
                    Common().makeImageResource(
                        albumModel.albumId!, "albums", .25, .4),
                    Positioned(
                        bottom: 0,
                        child: Common().glassmorphicContainer(
                            albumModel.albumName!, .4, .05))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
