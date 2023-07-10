import 'package:flutter/material.dart';
import 'package:music_app/utils/size_config.dart';

import '../../album/model/album_model.dart';
import '../../utils/common.dart';
import '../../utils/cs_text_style.dart';

class ArtistWidget{

 static Column artistTiles(BuildContext context, List<AlbumModel> topList,List<AlbumModel> newList){
    return Column(children: [
      SizedBox(
        height: SizeConfig.screenHeight * .02,
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 26, bottom: 10, right: 0, left: 15),
        width: SizeConfig.screenWidth,
        // decoration: BoxDecoration(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(42),
        //       topRight: Radius.circular(42),
        //     ),
        //     color: Theme.of(context).primaryColor,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCategoryTitle('TOP'),
            buildCustomAlbumList(topList),
            SizedBox(
              height: SizeConfig.screenHeight * .02,
            ),
            buildCategoryTitle('NEW'),
            buildCustomAlbumList(newList),
          ],
        ),
      ),
    ],);
  }

 static buildCategoryTitle(String title) {
   return Text(
     title,
     style: titleText2,
   );
 }

 static SizedBox buildCustomAlbumList(List<AlbumModel> albumList) {
   return SizedBox(
     height: SizeConfig.screenHeight * .25,
     child: ListView.builder(
         scrollDirection: Axis.horizontal,
         itemCount: albumList.length,
         itemBuilder: (context, index) {
           AlbumModel albumModel = albumList[index];
           return Common.mainTile(context, albumModel.albumId!,
               albumModel.albumId!, albumModel.albumName!, "albums");
         }),
   );
}



}