import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/album/ui/album_detail_page.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail_page.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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

  static AppBar makeAppbar(String title) {
    return AppBar(
      title: Text(
        title,
        style: normalText1,
      ),
      centerTitle: true,
      elevation: 0,
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
    return Center(
      child: CircularProgressIndicator(
      ),
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
          normalNavigate(context, AlbumDetailPage());
        } else if (type == "music") {
          context.read<MusicProvider>().getTrackDetail(trackId);
          normalNavigate(context, const MusicPlayer());
        } else {
          context.read<ArtistProvider>().getArtistDetail(id);
          normalNavigate(context, const ArtistDetailPage());
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
                        ? SizeConfig.screenWidth * .35:SizeConfig.screenWidth*.12,
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
}
