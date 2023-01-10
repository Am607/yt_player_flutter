//Copyright (c) 2020, the Flutter project authors. Please see the AUTHORS file
//for details. All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yt_player/src/enum/player_state.dart';
import 'package:yt_player/yt_player.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({
    super.key,
  });

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> with WidgetsBindingObserver {
  late YtController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Todo check what happend
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Todo check what happend
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Todo widget look up to the ancestor
    controller = YtController.of(context);
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          child: InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  supportZoom: false,
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  transparentBackground: true,
                  disableContextMenu: true,
                  disableHorizontalScroll: false,
                  disableVerticalScroll: false,
                  useShouldOverrideUrlLoading: true,
                ),
                android: AndroidInAppWebViewOptions(
                  allowContentAccess: true,
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                  allowsAirPlayForMediaPlayback: true,
                  allowsPictureInPictureMediaPlayback: true,
                )),
            initialData: InAppWebViewInitialData(
              data: player,
              encoding: 'utf-8',
              mimeType: 'text/html',
              baseUrl: Uri.parse('https://www.youtube.com/'),
            ),
            onWebViewCreated: (webController) {
              controller!.upDateValue(controller!.value.copyWith(
                webViewController: webController,
              ));

              webController
                ..addJavaScriptHandler(
                    handlerName: 'ready',
                    callback: (_) {
                      log('ready_detected');
                      controller!.upDateValue(controller!.value.copyWith(
                        isReady: true,
                      ));
                      // controller!.load(widget.id);
                    })
                ..addJavaScriptHandler(
                  handlerName: 'PlaybackQualityChange',
                  callback: (args) {
                    // controller!.updateValue(
                    //   controller!.value
                    //       .copyWith(playbackQuality: args.first as String),
                    // );
                  },
                )
                ..addJavaScriptHandler(
                  handlerName: 'stateChange',
                  callback: (args) {
                    switch (args.first as int) {
                      case -1:
                        controller!.upDateValue(controller!.value.copyWith(
                          playerState: PlayerState.unstarted,
                        ));
                        break;

                      case 0:
                        controller!.upDateValue(
                          controller!.value.copyWith(
                            playerState: PlayerState.ended,
                          ),
                        );
                        break;
                      case 1:
                        controller!.upDateValue(
                          controller!.value.copyWith(
                            playerState: PlayerState.playing,
                            isPlaying: true,
                            hasPlayed: true,
                            errorCode: 0,
                          ),
                        );
                        break;
                      case 2:
                        controller!.upDateValue(
                          controller!.value.copyWith(
                            playerState: PlayerState.paused,
                            isPlaying: false,
                          ),
                        );
                        break;
                      case 3:
                        controller!.upDateValue(
                          controller!.value.copyWith(
                            playerState: PlayerState.buffering,
                          ),
                        );
                        break;
                      case 5:
                        controller!.upDateValue(
                          controller!.value.copyWith(
                            playerState: PlayerState.videoCued,
                          ),
                        );
                        break;
                      default:
                        throw Exception("Invalid player state obtained.");
                    }
                  },
                )
                  ..addJavaScriptHandler(
              handlerName: 'VideoData',
              callback: (args) {
                controller!.upDateValue(
                  controller!.value.copyWith(
                      metaData: YoutubeMetaData.fromRawData(args.first)),
                );
              },
            );
            },
          ),
        ),
        InkWell(
          onTap: () {
            log('onTap_detected');
          },
          child: Container(
            height: 77,
            color: Colors.transparent,
          ),
        )
      ],
    );
  }

  String get player => ''' <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>Document</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        body{
            background-color: #000000;
                overflow: hidden;
                position: fixed;
                // max-height: max-content;
                height: 50vh;
                width: 100%;
                pointer-events: none;
              
        }
        </style>
</head>

<body>
    <div id="player"></div>
</body>


<script>
    var tag = document.createElement('script');
    tag.src = "//www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    var player;
    var timerId;
    onYouTubeIframeAPIReady = function () {
        player = new YT.Player('player', {
            frameborder: "0",
            height: '244',
            width: '434',
            // videoId: '6BX9nCiFd2k?modestbranding=1&autohide=1&quality=low', // youtube video id
            videoId: '${controller?.videoId}', // youtube video id
            playerVars: {
                'playsinline': 1,
                'controls': 0,
                'enablejsapi': 1,
                'fs': 0,
                'rel': 0,
                'showinfo': 0,
                'autoplay': 0,
                'modestbranding': 1,
            },
            events: {
              
                onReady: function(event){window.flutter_inappwebview.callHandler('ready');}
                onStateChange: function(event) { sendPlayerStateChange(event.data); },
            
               }
          });

       }
            function sendPlayerStateChange(playerState) {
                clearTimeout(timerId);
                window.flutter_inappwebview.callHandler('stateChange', playerState);
                if (playerState == 1) {
                    startSendCurrentTimeInterval();
                    sendVideoData(player);
                }
            }

             function sendVideoData(player) {
                var videoData = {
                    'duration': player.getDuration(),
                    'title': player.getVideoData().title,
                    'author': player.getVideoData().author,
                    'videoId': player.getVideoData().video_id
                };
                window.flutter_inappwebview.callHandler('VideoData', videoData);
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                    window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime(), player.getVideoLoadedFraction());
                }, 100);
            }

           function loadById(loadSettings) {
                player.loadVideoById(loadSettings);
                return '';
            }
             function play() {
                player.playVideo();
                return '';
            }

            function pause() {
                player.pauseVideo();
                return '';
            }

             function mute() {
                player.mute();
                return '';
            }

            function unMute() {
                player.unMute();
                return '';
            }
            function setVolume(volume) {
                player.setVolume(volume);
                return '';
            }

            function seekTo(position, seekAhead) {
                player.seekTo(position, seekAhead);
                return '';
            }

            function setSize(width, height) {
                player.setSize(width, height);
                return '';
            }

            function setPlaybackRate(rate) {
                player.setPlaybackRate(rate);
                return '';
            }

    function hideVideoTitle() {
        console.log('hideVideoTitle');
      
        const playerIFrame = document.querySelector("iframe");
        if (!playerIFrame) {
            return;
        }

        const frameDoc = playerIFrame.contentDocument;
        if (!frameDoc) {
            return;
        }

        const title = frameDoc.querySelector('.ytp-chrome-top');
        if (title) {
            title.style.display = 'none';
        }

          function setPlaybackQuality(playbackQuality) {
            if (playbackQuality == "auto") {
                localStorage.removeItem("yt-player-quality");         
            } else {
                var now = Date.now();
                localStorage.setItem("yt-player-quality", JSON.stringify({
                    data: playbackQuality,
                    creation: now,
                    expiration: now + 2419200000
                }));
            }
            if(player) {
                var currentTime = player.getCurrentTime();
                player.loadVideoById(player.getVideoData().video_id, currentTime);
            }
        }
    }
</script>
</html>
 ''';
}
