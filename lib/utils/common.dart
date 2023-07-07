import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail_layout.dart';
import 'package:music_app/artist/ui/artist_detail_mobile.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../album/ui/album_detail_layout.dart';
import '../music/provider/music_provider.dart';
import '../music/ui/music_player.dart';
import 'navigate.dart';

class Common {
  static const baseUrl =
      "https://napi-v2-2-cloud-run-b3gtd5nmxq-uw.a.run.app/v2.2/";

  static const apiKey = "NWMzNzExNmEtZmFhMi00ZjYwLWJhZTYtOWJlOTY4N2ZmNmFl";

  static String returnAlbumImgUrl(String id) {
    return "https://api.napster.com/imageserver/v2/albums/$id/images/500x500.jpg";
  }

  static const LinearGradient gradientColors =
      LinearGradient(colors: [Colors.white38, Colors.white38]);

  static Padding makeCustomAppbar(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_sharp)),
          SizedBox(
            width: SizeConfig.screenWidth * .3,
          ),
          Text(
            title,
            style: normalText1,
          ),
        ],
      ),
    );
  }

  static ClipRRect makeImageResource(
      String id, String type, double heightFactor, double widthFactor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        height: SizeConfig.screenHeight * heightFactor,
        width: SizeConfig.screenHeight * widthFactor,
        fit: BoxFit.cover,
        imageUrl: type == "albums" || type == "music"
            ? returnAlbumImgUrl(id)
            : "https://api.napster.com/imageserver/v2/artists/$id/images/230x153.jpg",
        placeholder: (context, url) => shimmerWidget(heightFactor, widthFactor),
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
    );
  }

  static Center circularProgressIndicator(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Center loadingIndicator(BuildContext context) {
    return Center(
        child: SpinKitWave(
      color: Theme.of(context).secondaryHeaderColor,
      size: 50.0,
    ));
  }

  static InkWell mainTile(BuildContext context, String trackId, String id,
      String name, String type) {
    bool isMobile = SizeConfig.screenWidth < 1000;
    return InkWell(
      onTap: () {
        if (type == "albums") {
          context.read<AlbumProvider>().getAlbumTracks(id);
          normalNavigate(context, const AlbumDetailLayout());
        } else if (type == "music") {
          context.read<MusicProvider>().getTrackDetail(trackId);
          normalNavigate(context, const MusicPlayer());
        } else {
          context.read<ArtistProvider>().getArtistDetail(id);
          normalNavigate(context, const ArtistDetailLayout());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        width: isMobile
            ? SizeConfig.screenWidth * .42
            : SizeConfig.screenWidth * .15,
        child: Stack(
          children: [
            Common.makeImageResource(id, type, .25, .4),
            Positioned(
              bottom: 0,
              child: GlassmorphicContainer(
                width: isMobile
                    ? SizeConfig.screenWidth * .42
                    : SizeConfig.screenWidth * .18,
                height: SizeConfig.screenHeight * .05,
                borderRadius: 0,
                linearGradient: gradientColors,
                border: 0,
                blur: 5,
                borderGradient: gradientColors,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    width: isMobile
                        ? SizeConfig.screenWidth * .35
                        : SizeConfig.screenWidth * .12,
                    child: Text(
                      name,
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
  }

  static Shimmer shimmerWidget(double heightFactor, double widthFactor) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200),
        width: SizeConfig.screenWidth * widthFactor,
        height: SizeConfig.screenHeight * heightFactor,
      ),
    );
  }

  static Future<PaletteColor> updatePalette(String id, bool isAlbum) async {
    PaletteColor colors;
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        Image.network(isAlbum ? Common.returnAlbumImgUrl(id) : id).image);

    colors =
        generator.lightMutedColor ?? PaletteColor(const Color(0xffffe5b4), 2);
    return colors;
  }

  static webHeader(BuildContext context, String id, String title, String type,
      String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 0, 25),
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_sharp))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          width: SizeConfig.screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Common.makeImageResource(id, type, .4, .35),
              SizedBox(
                width: SizeConfig.screenWidth * .01,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * .4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: SizeConfig.screenWidth * .5,
                        height: SizeConfig.screenHeight * .3,
                        child: Text(
                          title,
                          style: titleTextWeb,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      InkWell(
                        onTap: type == "albums"
                            ? () {
                                context
                                    .read<ArtistProvider>()
                                    .getArtistDetail(id);
                                normalNavigate(
                                  context,
                                  const ArtistDetailLayout(),
                                );
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            type == "albums"
                                ? Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 15.sp,
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(width: 15.sp),
                            SizedBox(
                              width: SizeConfig.screenWidth * .46,
                              child: Text(
                                subTitle,
                                overflow: TextOverflow.clip,
                                style: normalText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.sp,
        ),
      ],
    );
  }
}
