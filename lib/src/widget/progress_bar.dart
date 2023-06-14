import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:yt_player/src/utils/yt_controller.dart';

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  late YtController _controller;

  // double _playedValue = 0.0;
  // double _bufferedValue = 0.0;

  @override
  void didChangeDependencies() {
    final controller = YtController.of(context);
    if (controller == null) {
      // checking only the internal controller
      // but also can pass explicitly
      assert(true, 'No YtController found in context');
    } else {
      _controller = controller;
    }
    super.didChangeDependencies();
  }

  bool takeDragPosition = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: StreamBuilder<Object>(
          stream: _controller.getCurrentPositionStream(),
          builder: (context, snapshot) {
            // log('buffered position ${_controller.value.bufferdPosition}');

            // var positon = _controller.value.position;
            // late Duration dragPosition;
            // takePostion() {
            //   if (takeDragPosition) {
            //     return dragPosition;
            //   } else {
            //     return positon;
            //   }
            // }

            // log('takeDragPosition $takeDragPosition');

            return ProgressBar(
              timeLabelTextStyle: const TextStyle(color: Colors.white),
              timeLabelLocation: TimeLabelLocation.sides,
              progressBarColor: Colors.red,
              thumbRadius: 0,
              thumbColor: Colors.red,
              thumbCanPaintOutsideBar: false,
              // progress: takePostion(),
              progress: _controller.value.position,
              buffered: _controller.value.bufferdPosition,
              // buffered: const Duration(seconds: 10),
              total: _controller.value.youtubeMetaData.duration,
              onSeek: (duration) {
                _controller.seekTo(duration);
         
              },
              // onDragStart: (details) {
              //   setState(() {});
              // },
              // onDragEnd: (() {
              //   setState(() {
              //     Future.delayed(const Duration(seconds: 2)).then((value) {
              //       takeDragPosition = false;
              //     });
              //   });
              // }),
            );
          }),
    );
  }
}
