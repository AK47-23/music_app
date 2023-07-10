import 'package:flutter/cupertino.dart';
import 'package:music_app/artist/ui/artist_detail_mobile.dart';
import 'package:music_app/artist/ui/artist_detail_web.dart';

class ArtistDetailLayout extends StatelessWidget{
  const ArtistDetailLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth<800){
       return const  ArtistDetailMobile();
      }else{
        return const ArtistDetailWeb();
      }
    },);
  }

}