import 'dart:async';
import 'dart:developer';
import 'dart:html';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/album/provider/album_provider.dart';
import 'package:music_app/album/ui/album_detail_layout.dart';
import 'package:music_app/artist/provider/artist_provider.dart';
import 'package:music_app/artist/ui/artist_detail_layout.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/navigate.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MusicPlayerWeb extends StatefulWidget {
  const MusicPlayerWeb({super.key});

  @override
  State<MusicPlayerWeb> createState() => _MusicPlayerWebState();
}

class _MusicPlayerWebState extends State<MusicPlayerWeb> {
  bool init = true;
  double vol = 0.5;
  final audioElement = AudioElement();
  late Timer _timer;
  int _start = 30;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setVolume(double volume) {
    audioElement.volume = volume;
  }

  @override
  void initState() {
    // audioElement.onPlaying.listen((event) {
    //   setState(() {});
    // });
    customListener();

    // audioElement.onDurationChange.listen((event) {
    //
    //   log(event.timeStamp!.toString());
    //   setState(() {
    //     audioElement.currentTime= event.timeStamp!;
    //   });
    //
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  Widget makeBody(BuildContext context) {
    return context.watch<MusicProvider>().isLoading
        ? Common.loadingIndicator(context)
        : SingleChildScrollView(
            child: Column(children: [
            Consumer<MusicProvider>(builder: (context, value, widget) {
              TrackModel trackModel = value.trackModel;
              if (init) {
                audioElement.src = trackModel.previewUrl!;
                // audioElement.autoplay=true;
                audioElement.play();
                init = false;
                // audioElement.onPlaying.listen((event) {
                //   setState(() {
                //     position = audioElement.currentTime.toDouble();
                //   });
                // });
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * .05),
                    Common.makeCustomAppbar('NOW PLAYING', context),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<AlbumProvider>()
                                .getAlbumTracks(trackModel.albumId!);
                            normalNavigate(context, const AlbumDetailLayout());
                          },
                          child: Center(
                            child: trackModel.albumId != ''
                                ? Common.makeImageResource(
                                    trackModel.albumId!, "albums", .55, .5)
                                : Container(
                                    width: 65.sp,
                                    height: 65.sp,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(140),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.music_note,
                                        size: 50.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Slider(
                                    value: vol,
                                    min: 0.0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        vol = value;
                                      });
                                      setVolume(value);
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.volume_down,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * .05),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          trackModel.name!,
                          style: titleText1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(height: SizeConfig.screenHeight * .01),
                    InkWell(
                        onTap: () {
                          context
                              .read<ArtistProvider>()
                              .getArtistDetail(trackModel.artistId!);
                          normalNavigate(context, const ArtistDetailLayout());
                        },
                        child: Text(trackModel.artistName!, style: subTitle1)),
                  ]);
            }),
            SizedBox(height: SizeConfig.screenHeight * .03),
            Container(
              height: SizeConfig.screenHeight * .2,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: Theme.of(context).primaryColor),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (audioElement.paused) {
                              setState(() {
                                audioElement.play();
                              });
                            } else {
                              setState(() {
                                audioElement.pause();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              // minimumSize: Size(15.sp, 15.sp),
                              shape: const CircleBorder()),
                          child: Icon(
                            audioElement.paused
                                ? Icons.play_arrow
                                : Icons.pause,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ProgressBar(
                          progress: Duration(
                              seconds: audioElement.currentTime.toInt()),
                          total: const Duration(seconds: 29),
                          onSeek: (Duration duration) {
                            audioElement.currentTime = duration.inSeconds;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ]));
  }

  void customListener() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String timeFormat(int i) {
    return '00:${Duration(seconds: i).inSeconds.toString()}';
  }
}
