import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/home/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
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
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<AlbumProvider>(builder: (context, value, widget) {
            List<TrackModel> tracksList = value.tracksList;
            return tracksList.isNotEmpty
                ? CustomScrollView(slivers: [
                    SliverAppBar(
                      floating: true,
                      // centerTitle: true,
                      expandedHeight: SizeConfig.screenHeight * .3,

                      flexibleSpace: FlexibleSpaceBar(
                        title: Container(
                          alignment: Alignment.bottomCenter,
                          width: SizeConfig.screenWidth * .6,
                          child: InkWell(
                            onTap: () {
                              //TODO artist view
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tracksList[0].albumName!,
                                  style: whiteTitle1,
                                ),
                                Text(
                                  tracksList[0].artistName!,
                                  style: whiteTitle2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        background: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            height: SizeConfig.screenHeight * .3,
                            width: SizeConfig.screenHeight * .3,
                            fit: BoxFit.cover,
                            imageUrl: Common.returnImgUrl(
                              tracksList[0].albumId!,
                            ),
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
                        itemCount: tracksList.length,
                        itemBuilder: (context, index) {
                          TrackModel trackModel = tracksList[index];
                          return ListTile(
                            onTap: () {
                              context
                                  .read<MusicProvider>()
                                  .getTrackDetail(trackModel.id!);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MusicPlayer(),
                              ));
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
                    )
                  ])
                : Center(
                    child: Text(
                      'Something went wrong!',
                      style: titleText2,
                    ),
                  );
          });
  }
}
