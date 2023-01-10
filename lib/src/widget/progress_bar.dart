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

  double _playedValue = 0.0;
  double _bufferedValue = 0.0;

  @override
  void didChangeDependencies() {
    final controller = YtController.of(context);
    if(controller == null){
      // checking only the internal controller 
      // but also can pass explicitly
      assert(
        true,
        'No YtController found in context');
    }else{
      _controller = controller;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return ProgressBar(
      
      progress: _controller.value.position,
      // buffered: Duration(milliseconds: 2000),
      total: Duration(milliseconds: 300),
      onSeek: (duration) {
        log('User selected a new time: $duration');
      },
    );
  }
}
