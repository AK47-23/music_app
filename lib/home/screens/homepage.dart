import 'package:flutter/material.dart';
import 'package:music_app/album/model/album_model.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/home/provider/home_provider.dart';
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
  ScrollController artistScroll = ScrollController();

  int trackIndex = 8;
  int albumIndex = 8;
  int artistIndex = 8;

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
    // Fonts().init(context);
    return SafeArea(
      child: context.watch<HomeProvider>().isAlbumLoading &&
              context.watch<HomeProvider>().isTrackLoading &&
              context.read<HomeProvider>().isArtistLoading
          ? Common.loadingIndicator(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 7.0, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'RHYTHM',
                        style: titleText1,
                      ),
                    ),
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
                    SizedBox(
                      height: 25.sp,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Text title2Text(String text) {
    return Text(
      text,
      style: titleText2,
    );
  }

  Widget buildTopTrackList() {
    return Consumer<HomeProvider>(
        builder: (context, value, widget) {

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
                  return Common.mainTile(context, trackModel.id!,
                      trackModel.albumId!, trackModel.name!, "music");
                } else {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Common.circularProgressIndicator(context),
                  );
                }
              }));
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
                return Common.mainTile(context, albumModel.albumId!,
                    albumModel.albumId!, albumModel.albumName!, "albums");
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Common.circularProgressIndicator(context),
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
                return Common.mainTile(context, artistModel.id!,
                    artistModel.id!, artistModel.name!, "artists");
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Common.circularProgressIndicator(context),
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
