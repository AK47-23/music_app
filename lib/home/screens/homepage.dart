import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/album/ui/album_detail.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/home/provider/home_provider.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/music/ui/music_player.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
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
  ScrollController artistScroll= ScrollController();

  int trackIndex = 5;
  int albumIndex = 5;
  int artistIndex= 5;

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getTopTracks(trackIndex);
    context.read<HomeProvider>().getTopAlbums(albumIndex);
    context.read<HomeProvider>().getTopArtists(artistIndex);

    trackScroll.addListener(_trackScrollListener);
    albumScroll.addListener(_albumScrollListener);
    artistScroll.addListener(_artistScrollListener);
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
              context.watch<HomeProvider>().isTrackLoading && context.read<HomeProvider>().isArtistLoading
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
                   Center(child:Text(
                     'ECHO',
                     style: titleText1,
                   ), ),
                    SizedBox(
                      height: 15.sp,
                    ),
                   title2Text('Top Tracks'),
                    buildTopTrackList(),
                    SizedBox(
                      height: 15.sp,
                    ),
                   title2Text('Top Albums'),
                    buildTopAlbumList(),
                    SizedBox(
                      height: 15.sp,
                    ),
                    title2Text('Top Artists'),
                    buildTopArtistList(),
                  ],
                ),
              ),
            ),
    );
  }

  Text title2Text(String text){
    return  Text(
      text,
      style: titleText2,
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
                    normalNavigate(context, const MusicPlayer());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    width: SizeConfig.screenWidth * .42,
                    child: Stack(
                      children: [
                        Common().makeImageResource(
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
                    normalNavigate(context, AlbumDetail());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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

  Widget buildTopArtistList() {
    return Consumer<HomeProvider>(builder: (context, value, widget) {
      List<ArtistModel> artistList = value.artistsList;
      return SizedBox(
        height: SizeConfig.screenHeight * .25,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artistList.length + 1,
            controller: artistScroll,
            itemBuilder: (context, index) {
              if (index < artistList.length) {
                ArtistModel artistModel = artistList[index];
                return InkWell(
                  onTap: () {
                    context
                        .read<ArtistProvider>()
                        .getArtistDetail(artistModel.id!);
                    normalNavigate(context,const ArtistDetailPage());
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    width: SizeConfig.screenWidth * .4,
                    child: Stack(
                      children: [
                        Common().makeImageResource(
                            artistModel.id!, "artists", .25, .4),
                        Positioned(
                            bottom: 0,
                            child: Common().glassmorphicContainer(
                                artistModel.name!, .4, .05))
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

  _artistScrollListener() {
    if (context.read<HomeProvider>().isArtistLoading) return;
    if (artistScroll.position.pixels == artistScroll.position.maxScrollExtent) {
      artistIndex += 5;
      context.read<HomeProvider>().getTopArtists(artistIndex);
    }
  }
}
