import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/artist/widgets/artist_widgets.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../utils/common.dart';
import '../../utils/cs_text_style.dart';
import '../../utils/size_config.dart';
import '../model/artist_model.dart';
import '../provider/artist_provider.dart';

class ArtistDetailWeb extends StatefulWidget {
  const ArtistDetailWeb({super.key});

  @override
  State<ArtistDetailWeb> createState() => _ArtistDetailWebState();
}

class _ArtistDetailWebState extends State<ArtistDetailWeb> {
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
    return context.watch<ArtistProvider>().isArtistLoading
        ? Common.loadingIndicator(context)
        : SingleChildScrollView(
            child: Consumer<ArtistProvider>(builder: (context, value, widget) {
              ArtistModel artistModel = value.artistModel;
              return Stack(children: [
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: SizeConfig.screenHeight * .5,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        value.colors.color,
                        Colors.black87,
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Common.webHeader(
                          context,
                          artistModel.id!,
                          artistModel.name!,
                          'artist',
                          '${formatter.format(number)} monthly listeners'),
                      ArtistWidget.artistTiles(
                          context, value.topList, value.newList),
                      SizedBox(
                        height: SizeConfig.screenHeight * .05,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15  ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: titleText2,
                            ),
                            Container(
                              width: SizeConfig.screenWidth ,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: ReadMoreText(
                                artistModel.bio!,
                                trimLines: 3,
                                style: subTitle1,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                moreStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            }),
          );
  }
}
