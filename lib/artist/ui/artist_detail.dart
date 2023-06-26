import 'package:flutter/material.dart';
import 'package:music_app/artist/model/artist_model.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/utils/common.dart';
import 'package:provider/provider.dart';

class ArtistDetailPage extends StatelessWidget {
  const ArtistDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Common().makeAppbar('ARTIST DETAIL'),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 60),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     'Artist Detail',
            //     style: TextStyle(
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            // SizedBox(height: 20),
            // Text(
            //   "artistName",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // SizedBox(height: 20),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     " adasdasdas",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            makeBody(context),
          ],
        ),
      ),
    );
  }

  makeBody(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ArtistProvider>(builder: (context, value, widget) {
        ArtistModel artistModel = value.artistModel;
        return Column(
          children: [
            Common().makeImageResoure(artistModel.id!, "artists", .2, .2),
          ],
        );
      }),
    );
  }
}
