import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatelessWidget {
  const AlbumDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    return context.watch<AlbumProvider>().isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    height: SizeConfig.screenHeight * .25,
                    width: SizeConfig.screenWidth * .4,
                    fit: BoxFit.cover,
                    imageUrl: Common.returnImgUrl("trackModel.albumId!"),
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
            SliverToBoxAdapter()
          ]);
  }
}
