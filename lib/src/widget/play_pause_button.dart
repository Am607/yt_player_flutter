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
            InkWell(
              onTap: () {
                _controller.seekTo(
                    _controller.value.position - const Duration(seconds: 10));
                // controller.seekTo(const Duration(seconds: 10));
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
               setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child:  Icon(
                    !_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
           
           InkWell(
              onTap: () {
                _controller.seekTo(
                    _controller.value.position + const Duration(seconds: 10));
                // controller.seekTo(const Duration(seconds: 10));
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        
            
          ],
        ),
      ),
    );
  }
}
