import 'dart:developer';

import 'dart:html';

import 'package:assets_audio_player/assets_audio_player.dart';
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
import 'package:volume_controller/volume_controller.dart';

class MusicPlayerMobile extends StatefulWidget {
  const MusicPlayerMobile({super.key});

  @override
  State<MusicPlayerMobile> createState() => _MusicPlayerMobileState();
}

class _MusicPlayerMobileState extends State<MusicPlayerMobile> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  double setVolumeValue = 0;
  bool init = true;
  bool play = true;
  double vol = 0;
  final audioElement = AudioElement();

  @override
  void initState() {
    super.initState();
    init = true;

    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    VolumeController().listener((volume) {
      setState(() => setVolumeValue = volume);
    });

    VolumeController().getVolume().then((volume) => setVolumeValue = volume);
  }

  void setVolume(double volume) {
    audioElement.volume = volume;
    audioElement.play();
  }

  initialise(TrackModel trackModel) async {
    try {
      audioElement.src = trackModel.previewUrl!;

      await assetsAudioPlayer.open(
          playInBackground: PlayInBackground.enabled,
          Audio.network(trackModel.previewUrl!,
              metas: Metas(
                image: MetasImage.network(
                    Common.returnAlbumImgUrl(trackModel.albumId!)),
                title: trackModel.name,
                artist: trackModel.artistName,
                album: trackModel.albumName,
              )),
          autoStart: true,
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
          audioFocusStrategy:
              const AudioFocusStrategy.request(resumeAfterInterruption: true),
          showNotification: true,
          notificationSettings: const NotificationSettings(
            seekBarEnabled: true,
            playPauseEnabled: true,
            nextEnabled: true,
            prevEnabled: true,
            stopEnabled: true,
          ));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    VolumeController().removeListener();
    log('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(context),
    );
  }

  Widget makeBody(BuildContext context) {
    log(vol.toString());
    return context.watch<MusicProvider>().isLoading
        ? Common.loadingIndicator(context)
        : SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              // bool isMobile = constraints.maxWidth < 600;
              return Column(
                children: [
                  Consumer<MusicProvider>(builder: (context, value, widget) {
                    TrackModel trackModel = value.trackModel;
                    if (init) {
                      initialise(trackModel);

                      init = false;
                    }
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * .05),
                          Common.makeCustomAppbar('NOW PLAYING', context),
                          InkWell(
                            onTap: () {
                              context
                                  .read<AlbumProvider>()
                                  .getAlbumTracks(trackModel.albumId!);
                              normalNavigate(
                                  context, const AlbumDetailLayout());
                            },
                            child: Center(
                              child: trackModel.albumId != ''
                                  ? Common.makeImageResource(
                                      trackModel.albumId!,
                                      "albums",
                                      // isMobile ?
                                      .35,
                                      // : .55,
                                      // isMobile ?
                                      .3,
                                      // : .5
                                    )
                                  : Container(
                                      width: 65.sp,
                                      height: 65.sp,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(140),
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
                          Slider(
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
                          SizedBox(height: SizeConfig.screenHeight * .05),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                normalNavigate(
                                    context, const ArtistDetailLayout());
                              },
                              child: Text(trackModel.artistName!,
                                  style: subTitle1)),
                        ]);
                  }),
                  SizedBox(height: SizeConfig.screenHeight * .03),
                  Container(
                    height: SizeConfig.screenHeight * .35,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35)),
                        color: Theme.of(context).primaryColor),
                    child: Column(
                      children: [
                        assetsAudioPlayer.builderIsBuffering(
                          builder: (context, isBuffering) {
                            if (isBuffering) {
                              return const CircularProgressIndicator();
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        assetsAudioPlayer.builderRealtimePlayingInfos(
                            builder: (context, RealtimePlayingInfos? infos) {
                          if (infos == null || infos.isBuffering) {
                            return const SizedBox();
                          }
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  ProgressBar(
                                    progress: infos.currentPosition,
                                    total: const Duration(seconds: 29),
                                    onSeek: (Duration duration) {
                                      assetsAudioPlayer.seek(duration);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            assetsAudioPlayer.seekBy(
                                                const Duration(seconds: -10));
                                          },
                                          icon:
                                              const Icon(Icons.skip_previous)),
                                      ElevatedButton(
                                        onPressed: () {
                                          assetsAudioPlayer.playOrPause();
                                          // infos.isPlaying
                                          //     ? assetsAudioPlayer.pause()
                                          //     : assetsAudioPlayer.play();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(35.sp, 35.sp),
                                            shape: const CircleBorder()),
                                        child: Icon(
                                          infos.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            assetsAudioPlayer.seekBy(
                                                const Duration(seconds: 10));
                                          },
                                          icon: const Icon(Icons.skip_next)),
                                    ],
                                  )
                                ],
                              )
                              // : Row(
                              //     children: [
                              //       Expanded(
                              //         flex:1,
                              //         child: IconButton(onPressed: () {
                              //           assetsAudioPlayer.seekBy(const Duration(seconds: -10));
                              //         }, icon:const Icon(Icons.skip_previous)),
                              //       ),
                              //       Expanded(
                              //         flex: 1,
                              //         child: ElevatedButton(
                              //
                              //           onPressed: () {
                              //             assetsAudioPlayer.playOrPause();
                              //           },
                              //           style: ElevatedButton.styleFrom(
                              //             padding: const EdgeInsets.all(12),
                              //               // minimumSize: Size(15.sp, 15.sp),
                              //               shape: const CircleBorder()),
                              //           child: Icon(
                              //             infos.isPlaying
                              //                 ? Icons.pause
                              //                 : Icons.play_arrow,
                              //             color: Colors.white,
                              //             size: 20.sp,
                              //           ),
                              //         ),
                              //       ),
                              //       Expanded(
                              //         flex:1,
                              //         child: IconButton(onPressed: () {
                              //           assetsAudioPlayer.seekBy(const Duration(seconds: 10));
                              //         }, icon: const Icon(Icons.skip_next)),
                              //       ),
                              //       Expanded(
                              //         flex: 4,
                              //         child: ProgressBar(
                              //           progress: infos.currentPosition,
                              //           total: const Duration(seconds: 29),
                              //           onSeek: (Duration duration) {
                              //             assetsAudioPlayer.seek(duration);
                              //           },
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              );
                        }),
                        PlayerBuilder.volume(
                            player: assetsAudioPlayer,
                            builder: (context, volume) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.volume_down,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: setVolumeValue,
                                        onChanged: (double value) {
                                          setState(() {
                                            setVolumeValue = value;
                                            VolumeController()
                                                .setVolume(setVolumeValue);
                                          });
                                        },
                                        inactiveColor: Colors.grey[800],
                                      ),
                                    ),
                                    Icon(
                                      Icons.volume_up,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
  }
}
