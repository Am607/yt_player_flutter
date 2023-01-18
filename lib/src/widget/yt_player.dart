import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yt_player/src/widget/bottom_controls.dart';
import 'package:yt_player/src/widget/play_pause_button.dart';
import 'package:yt_player/src/widget/progress_bar.dart';
import 'package:yt_player/yt_player.dart';

// wraper p
// class YtPlayer extends StatefulWidget {
//   /// A [YtPlayerBase] controller for [YtPlayerBase]
//   final YtController controller;
//
//   ///called when the player is ready to preform operation
//   final VoidCallback? onReady;
//   const YtPlayer({super.key, required this.controller, this.onReady});
//
//   @override
//   State<YtPlayer> createState() => _YtPlayerState();
// }
//
// class _YtPlayerState extends State<YtPlayer> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeMetrics() {
//     log('didChangeMetrics');
//     super.didChangeMetrics();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget portrait() =>
//         YtPlayerBase(controller: widget.controller, onReady: widget.onReady);
//     Widget landscape() => WillPopScope(
//         onWillPop: () async {
//           final controller = widget.controller;
//           if (controller.value.isFullScreen) {
//             widget.controller.toggleFullScreenMode(context);
//             return false;
//           }
//           return true;
//         },
//         child: YtPlayerBase(controller: widget.controller, onReady: widget.onReady));
//     return OrientationBuilder(
//       builder: ((context, orientation) {
//         return orientation == Orientation.portrait ? portrait() : landscape();
//       }),
//     );
//   }
// }

class YtPlayerBase extends StatefulWidget {
  /// A [YtPlayerBase] controller for [YtPlayerBase]
  final YtController controller;

  ///called when the player is ready to preform operation
  final VoidCallback? onReady;

  /// create a [YtPlayerBase] widget
  const YtPlayerBase({super.key, required this.controller, this.onReady});

  @override
  State<YtPlayerBase> createState() => _YtPlayerBaseState();
}

class _YtPlayerBaseState extends State<YtPlayerBase> {
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
  Orientation? orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 0,
      color: Colors.black,
      child: InheritedYtPlayer(
        controller: controller,
        child: Container(
          color: Colors.black87,
          // width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // fit: StackFit.expand,
              // clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    log('tap up');
                  },
                  onPanUpdate: (details) {
                    log('pan update');
                    log(details.localPosition.toString());
                  },
                  onDoubleTap: (() {
                    log('double tap');
                    controller.togglePlayPause();
                  }),
                  child: SizedBox(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SizedBox(
                        width: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width
                            : null,
                        height: orientation == Orientation.landscape
                            ? MediaQuery.of(context).size.height
                            : null,
                        child: const BottomPlayer(),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: PlayPauseButton(),
                ),
                Positioned(
                  bottom: 34,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      controller.toggleFullScreenMode(context);
                    },
                    icon: Icon(
                      controller.value.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: ProgressBarWidget(),
                ),
                const Positioned(bottom: 3, left: 0, child: BottomControls()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
