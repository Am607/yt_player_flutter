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

  List playBackSpeed = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5];
  int currentSoundindex = 2;

  List qualityies = ["hd1080", "hd720", "large", "medium", "small", "tiny", "auto"];
  List qualityNames = ["1080p", "720p", "480p", "360p", "240p", "144p", "Auto"];
  int currentQulityindex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            // log('mute ${_controller.value.muted}');
            setState(
              () {
                _controller.value.muted ? _controller.unMute() : _controller.mute();
              },
            );
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
            //! setting pop up
            _controller.getQuality();

            showBottomSheet(
                context: context,
                builder: ((context) {
                  return Wrap(
                    children: [
                      InkWell(
                        onTap: () {
                          //! play back spped pop up
                          showBottomSheet(
                              context: context,
                              builder: ((context) {
                                return Wrap(
                                  children: List.generate(
                                      playBackSpeed.length,
                                      (index) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                currentSoundindex = index;
                                                _controller.setPlayBackRate(
                                                    playBackSpeed[currentSoundindex]);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: ListTile(
                                              leading: currentSoundindex == index
                                                  ? const Icon(Icons.check)
                                                  : null,
                                              title: Text('${playBackSpeed[index]}x'),
                                            ),
                                          )),
                                );
                              }));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.speed),
                          title: const Text('Play Back Speed'),
                          trailing: Text('${playBackSpeed[currentSoundindex]}x'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // ! quality pop up
                          // Todo bug fixes
                          final d = _controller.value.availableQualities;
                          log('availableQualities $d');
                          showBottomSheet(
                            context: context,
                            builder: ((context) {
                              return Wrap(
                                children: List.generate(
                                  d?.length ?? 0,
                                  (index) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentQulityindex = index;
                                        _controller.changeVideoQuality(
                                            d?[currentQulityindex] ?? 'Auto');
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      leading: currentQulityindex == index
                                          ? const Icon(Icons.check)
                                          : null,
                                      title: Text('${d?[index]}'),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.high_quality),
                          title: const Text('Quality'),
                          trailing: Text('${qualityNames[currentQulityindex]}'),
                        ),
                      )
                    ],
                  );
                }));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 3),
            child:

                //  Text(
                //   '${playBackSpeed[currentSoundindex]}x',
                //   style: const TextStyle(
                //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                // ),

                Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 3),
            child: Text(
              '${qualityNames[currentQulityindex]}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),

            //  Icon(
            //   Icons.settings,
            //   color: Colors.white,
            //   size: 20,
            // ),
          ),
        ),
      ],
    );
  }
}
