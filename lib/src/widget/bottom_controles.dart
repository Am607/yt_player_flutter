import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yt_player/src/utils/yt_controller.dart';

class BottomControls extends StatefulWidget {
  const BottomControls({super.key});

  @override
  State<BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<BottomControls> {
  late YtController _controller;
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

  List playBackSpeed = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0 , 2.5];
  int currentSoundindex = 3;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            log('mute ${_controller.value.muted}');
            setState(() {
              _controller.value.muted ? _controller.unMute() : _controller.mute();
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 38, bottom: 3),
            child: Icon(
              _controller.value.muted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // controller.value. ? controller.unMute() : controller.mute();
            setState(() {
              currentSoundindex++;
              if (currentSoundindex > playBackSpeed.length - 1) {
                currentSoundindex = 0;
              }
              _controller.setPlayBackRate(playBackSpeed[currentSoundindex]);
            });
          },
          child:  Padding(
            padding:const EdgeInsets.only(left: 15, bottom: 3),
            child: Text(
              '${playBackSpeed[currentSoundindex]}x',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // controller.value. ? controller.unMute() : controller.mute();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 3),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
