import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/home/screens/homepage.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home/provider/home_provider.dart';

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => HomeProvider(),
          ),
          ChangeNotifierProvider<AlbumProvider>(
            create: (context) => AlbumProvider(),
          ),
          ChangeNotifierProvider<MusicProvider>(
            create: (context) => MusicProvider(),
          ),
          ChangeNotifierProvider<ArtistProvider>(
            create: (context) => ArtistProvider(),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Music App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        }),
      );
    });
  }
}
