import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yt_player/src/widget/bottom_controles.dart';
import 'package:yt_player/src/widget/play_pause_button.dart';
import 'package:yt_player/src/widget/progress_bar.dart';
import 'package:yt_player/yt_player.dart';

class YtPlayer extends StatefulWidget {
  /// A [YtPlayer] controller for [YtPlayer]
  final YtController controller;

  ///called when the player is ready to preform operation
  final VoidCallback? onReady;

  /// create a [YtPlayer] widget
  const YtPlayer({super.key, required this.controller, this.onReady});

  @override
  State<YtPlayer> createState() => _YtPlayerState();
}

class _YtPlayerState extends State<YtPlayer> {
  late YtController controller;
  @override
  void initState() {
    controller = widget.controller..addListener(listner);
    if (controller.value.isReady) {}
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listner);
    super.dispose();
  }

  void listner() async {
    // controller.play();
    if (mounted) setState(() {});
  }

//  final GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InheritedYtPlayer(
      controller: controller,
      child: Container(
        color: Colors.black87,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // fit: StackFit.expand,
            // clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: SizedBox(
                  width: width,
                  child: Transform.scale(
                    scale: controller.value.isFullScreen
                        ? (1 / (16 / 9) * MediaQuery.of(context).size.width) /
                            MediaQuery.of(context).size.height
                        : 1,
                    child: const BottomPlayer(),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: PlayPauseButton(),
              ),
              Positioned(
                bottom: 26,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      controller.toggleFullScreenMode();
                    },
                    icon: Icon(
                      controller.value.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    )),
              ),
              const Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: ProgressBarWidget(),
              ),
              const Positioned(bottom: 0, left: 0, child: BottomControls()),
            ],
          ),
        ),
      ),
    );
  }
}
