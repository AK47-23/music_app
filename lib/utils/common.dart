import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';

class Common {
  static const baseUrl =
      "https://napi-v2-2-cloud-run-b3gtd5nmxq-uw.a.run.app/v2.2/";

  static const apiKey = "NWMzNzExNmEtZmFhMi00ZjYwLWJhZTYtOWJlOTY4N2ZmNmFl";

  static String returnAlbumImgUrl(String id) {
    return "https://api.napster.com/imageserver/v2/albums/$id/images/500x500.jpg";
  }

  LinearGradient gradientColors =
      const LinearGradient(colors: [Colors.white38, Colors.white38]);

  AppBar makeAppbar(String title) {
    return AppBar(
      title: Text(
        title,
        style: normalText1,
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  ClipRRect makeImageResource(
      String id, String type, double heightFactor, double widthFactor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        height: SizeConfig.screenHeight * heightFactor,
        width: SizeConfig.screenHeight * widthFactor,
        fit: BoxFit.cover,
        imageUrl: type == "albums"
            ? Common.returnAlbumImgUrl(id)
            : "https://api.napster.com/imageserver/v2/artists/$id/images/230x153.jpg",
        placeholder: (context, url) =>  Common().circularProgressIndicator(context),

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

  GlassmorphicContainer glassmorphicContainer(
      String title, double widthFactor, double heightFactor) {
    return GlassmorphicContainer(
      width: SizeConfig.screenWidth * widthFactor,
      height: SizeConfig.screenHeight * heightFactor,
      borderRadius: 0,
      linearGradient: gradientColors,
      border: 0,
      blur: 5,
      borderGradient: gradientColors,
      child: Container(
          padding: const EdgeInsets.only(left: 5),
          alignment: Alignment.center,
          width: SizeConfig.screenWidth * .35,
          child: Text(
            title,
            style: normalText1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }

  Center circularProgressIndicator(BuildContext context){
    return  Center(child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor,),);
  }

  Center loadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Theme.of(context).secondaryHeaderColor,
        size: 50.0,)
    );
  }
}
