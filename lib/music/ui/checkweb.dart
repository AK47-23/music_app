import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:music_app/music/ui/music_player_mobile.dart';
import 'package:music_app/music/ui/music_player_web.dart';

class MusicLayout extends StatelessWidget{
  const MusicLayout({super.key});

  @override
  Widget build(BuildContext context) {
     //Platform.isAndroid?
    return Platform.isAndroid?const MusicPlayerMobile():const MusicPlayerWeb();
  }

}