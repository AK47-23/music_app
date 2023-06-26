import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/music/model/track_model.dart';
import 'package:music_app/music/provider/music_provider.dart';
import 'package:music_app/utils/common.dart';
import 'package:music_app/utils/cs_text_style.dart';
import 'package:music_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  late final Audio audio;
  double setVolumeValue = 0;
  bool init = true;

  TrackModel trackModel = TrackModel('', '', '', '', '', '', '');

  @override
  void initState() {
    super.initState();
    init = true;
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

    VolumeController().listener((volume) {
      setState(() => setVolumeValue = volume);
    });

    VolumeController().getVolume().then((volume) => setVolumeValue = volume);

    initialise();
  }

  initialise() async {
    trackModel = context.read<MusicProvider>().trackModel;
    try {
      await assetsAudioPlayer.open(
          Audio.liveStream(trackModel.previewUrl!,
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
      backgroundColor: Colors.grey.shade100,
      appBar: Common().makeAppbar('NOW PLAYING'),
      body: context.watch<MusicProvider>().isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<MusicProvider>(builder: (context, value, widget) as{
                    TrackModel trackModel = value.trackModel;
                    if (init) {
                      initialise();
                      init = false;
                      log("message");
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * .05),
                        Center(
                          child: trackModel.albumId != ''
                              ? Common().makeImageResoure(
                                  trackModel.albumId!, "albums", .35, .3)
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
                              //TODO
                            },
                            child:
                                Text(trackModel.artistName!, style: subTitle1)),
                        SizedBox(height: SizeConfig.screenHeight * .03),
                        Container(
                          height: SizeConfig.screenHeight * .35,
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              color: Colors.white60),
                          child: Column(
                            children: [
                              assetsAudioPlayer.builderRealtimePlayingInfos(
                                  builder:
                                      (context, RealtimePlayingInfos? infos) {
                                if (infos == null) {
                                  return const SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    children: [
                                      ProgressBar(
                                        progress: infos.currentPosition,
                                        total: const Duration(seconds: 29),
                                        onSeek: (Duration duration) {
                                          assetsAudioPlayer.seek(duration);
                                        },
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          assetsAudioPlayer.playOrPause();
                                          // infos.isPlaying
                                          //     ? assetsAudioPlayer.pause()
                                          //     : assetsAudioPlayer.play();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            minimumSize: Size(35.sp, 35.sp),
                                            shape: const CircleBorder()),
                                        child: Icon(
                                          infos.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                              PlayerBuilder.volume(
                                  player: assetsAudioPlayer,
                                  builder: (context, volume) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  VolumeController().setVolume(
                                                      setVolumeValue);
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
                ],
              ),
            ),
    );
  }
}
