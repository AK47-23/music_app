import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/home/model/track_model.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatelessWidget {
  AlbumDetail({super.key});

  final NumberFormat formatter = NumberFormat("00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    SizeConfig().init(context);
    return context.watch<AlbumProvider>().isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<AlbumProvider>(builder: (context, value, widget) {
            // List<TrackModel> tracksList = value.tracksList;
            // return tracksList.isNotEmpty
            //     ? TODO
            return CustomScrollView(slivers: [
              SliverAppBar(
                floating: true,
                centerTitle: true,
                expandedHeight: SizeConfig.screenHeight * .35,
                leading: const Icon(Icons.arrow_back),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "tracksList[0].albumName!",
                    style: whiteText1,
                  ),
                  background: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          // Common.returnImgUrl(
                          // tracksList[0].albumId!
                          "https://i.imgur.com/g2M5B2S.jpg",
                      // ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 300,
                        width: 300,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    // TrackModel trackModel = tracksList[index];
                    return ListTile(
                      shape: ,
                      leading: Text(
                        '#${formatter.format(index + 1)}',
                        style: normalText1,
                      ),
                      title: Text(
                        "trackModel.name!",
                        style: normalText1,
                      ),
                      subtitle: Text(
                        "trackModel.artistName!",
                        style: subTitle1,
                      ),
                      trailing: Text("duration"),
                    );
                  },
                ),
              )
            ])
                // : Center(
                //     child: Text(
                //       'Something went wrong!',
                //       style: titleText2,
                //     ),
                //   )
                ;
          });
  }
}
