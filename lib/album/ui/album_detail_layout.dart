import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/album/ui/album_detail_mobile.dart';
import 'package:music_app/album/ui/album_detail_web.dart';
import 'package:music_app/utils/size_config.dart';

class AlbumDetailLayout extends StatelessWidget{
  const AlbumDetailLayout({super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth<800){
    return const AlbumDetailMobile();
      }else{
       return  AlbumDetailWeb();
      }
    },);
  }

}