import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/album/widgets/album_widgets.dart';
import 'package:provider/provider.dart';
import '../../music/model/track_model.dart';
import '../../utils/common.dart';
import '../../utils/size_config.dart';
import '../provider/album_provider.dart';

class AlbumDetailWeb extends StatefulWidget {
  const AlbumDetailWeb({super.key});

  @override
  State<AlbumDetailWeb> createState() => _AlbumDetailWebState();
}

class _AlbumDetailWebState extends State<AlbumDetailWeb> {
  final NumberFormat formatter = NumberFormat("#,###,000");
  Random random = Random();
  int number = 0;

  @override
  void initState() {
    number = 10000 + random.nextInt(1000000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  makeBody(BuildContext context) {
    return context.watch<AlbumProvider>().isLoading
        ? Common.loadingIndicator(context)
        : SingleChildScrollView(
            child: Consumer<AlbumProvider>(builder: (context, value, widget) {
              List<TrackModel> tracksList = value.tracksList;
              return Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: SizeConfig.screenHeight * .5,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              value.colors.color,
                              Colors.black87,
                            ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft)),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Common.webHeader(
                            context,
                            tracksList[0].albumId!,
                            tracksList[0].albumName!,
                            'albums',
                            '${tracksList[0].artistName} • ${tracksList.length} songs • ${formatter.format(number)} likes', tracksList[0].artistId!),
                        AlbumWidgets().musicList(tracksList),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
  }
}
