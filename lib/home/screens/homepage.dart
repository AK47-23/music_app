import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/album/ui/album_detail.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/home/provider/home_provider.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController trackScroll = ScrollController();
  ScrollController albumScroll = ScrollController();

  int trackIndex = 5;
  int albumIndex = 5;

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getTopTracks(trackIndex);
    context.read<HomeProvider>().getTopAlbums(albumIndex);

    trackScroll.addListener(_trackScrollListener);
    albumScroll.addListener(_albumScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  Widget makeBody(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: context.watch<HomeProvider>().isAlbumLoading &&
              context.watch<HomeProvider>().isTrackLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 7.0, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Browse',
                      style: titleText1,
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),
                    Text(
                      'Top Tracks',
                      style: titleText2,
                    ),
                    buildTopTrackList(),
                    SizedBox(
                      height: 30.sp,
                    ),
                    Text(
                      'Top Albums',
                      style: titleText2,
                    ),
                    buildTopAlbumList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTopTrackList() {
    return Consumer<HomeProvider>(builder: (context, value, widget) {
      List<TrackModel> trackList = value.tracksList;
      return SizedBox(
        height: SizeConfig.screenHeight * .25,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: trackScroll,
            itemCount: trackList.length + 1,
            itemBuilder: (context, index) {
              if (index < trackList.length) {
                TrackModel trackModel = trackList[index];
                return InkWell(
                  onTap: () {
                    context
                        .read<MusicProvider>()
                        .getTrackDetail(trackModel.id!);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MusicPlayer(),
                    ));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    width: SizeConfig.screenWidth * .42,
                    child: Stack(
                      children: [
                        Common().makeImageResoure(
                            trackModel.albumId!, "albums", .25, .4),
                        Positioned(
                          bottom: 0,
                          child: GlassmorphicContainer(
                            width: SizeConfig.screenWidth * .4,
                            height: SizeConfig.screenHeight * .05,
                            borderRadius: 0,
                            linearGradient: Common().gradientColors,
                            border: 0,
                            blur: 5,
                            borderGradient: Common().gradientColors,
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth * .35,
                                child: Text(
                                  trackModel.name!,
                                  style: normalText1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const CircularProgressIndicator(),
                );
              }
            }),
      );
    });
  }

  Widget buildTopAlbumList() {
    return Consumer<HomeProvider>(builder: (context, value, widget) {
      List<AlbumModel> albumList = value.albumList;
      return SizedBox(
        height: SizeConfig.screenHeight * .25,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: albumList.length + 1,
            controller: albumScroll,
            itemBuilder: (context, index) {
              if (index < albumList.length) {
                AlbumModel albumModel = albumList[index];
                return InkWell(
                  onTap: () {
                    context
                        .read<AlbumProvider>()
                        .getAlbumTracks(albumModel.albumId!);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AlbumDetail(),
                    ));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    width: SizeConfig.screenWidth * .4,
                    child: Stack(
                      children: [
                        Common().makeImageResoure(
                            albumModel.albumId!, "albums", .25, .4),
                        Positioned(
                          bottom: 0,
                          child: GlassmorphicContainer(
                            width: SizeConfig.screenWidth * .4,
                            height: SizeConfig.screenHeight * .05,
                            borderRadius: 0,
                            linearGradient: const LinearGradient(
                                colors: [Colors.white38, Colors.white38]),
                            border: 0,
                            blur: 5,
                            borderGradient: const LinearGradient(
                                colors: [Colors.white38, Colors.white38]),
                            child: Container(
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth * .35,
                                child: Text(
                                  albumModel.albumName!,
                                  style: normalText1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const CircularProgressIndicator(),
                );
              }
            }),
      );
    });
  }

  _trackScrollListener() {
    if (context.read<HomeProvider>().isTrackLoading) return;
    if (trackScroll.position.pixels == trackScroll.position.maxScrollExtent) {
      trackIndex += 5;
      context.read<HomeProvider>().getTopTracks(trackIndex);
    }
  }

  _albumScrollListener() {
    if (context.read<HomeProvider>().isAlbumLoading) return;
    if (albumScroll.position.pixels == albumScroll.position.maxScrollExtent) {
      albumIndex += 5;
      context.read<HomeProvider>().getTopAlbums(albumIndex);
    }
  }
}
