import 'package:flutter/material.dart';
import 'package:yt_player/src/utils/yt_controller.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late YtController _controller;

  // double _playedValue = 0.0;
  // double _bufferedValue = 0.0;

  @override
  void didChangeDependencies() {
    final controller = YtController.of(context);
    if (controller == null) {
      assert(true, 'No YtController found in context');
    } else {
      _controller = controller;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {
                _controller
                    .seekTo(_controller.value.position - const Duration(seconds: 10));
                // controller.seekTo(const Duration(seconds: 10));
              },
              icon: const Icon(
                Icons.replay_10,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              icon: Icon(
                !_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                // _controller.setQuality('tiny');
                // _controller
                // .seekTo(_controller.value.position + const Duration(seconds: 10));
                _controller.toggleFullScreenMode(context);
                // controller.seekTo(const Duration(seconds: 10));
              },
              icon: const Icon(
                Icons.forward_10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
