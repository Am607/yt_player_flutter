//Copyright (c) 2020, the Flutter project authors. Please see the AUTHORS file
//for details. All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yt_player/src/enum/player_state.dart';
import 'package:yt_player/src/utils/mete_data.dart';
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

  WebStorageManager webStorageManager = WebStorageManager.instance();
  CookieManager cookieManager = CookieManager.instance();
  // set the expiration date for the cookie in milliseconds
  final expiresDate =  DateTime.now().add(Duration(days: 3)).millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    // Todo widget look up to the ancestor

    controller = YtController.of(context);
    final size = MediaQuery.of(context).size;
    return IgnorePointer(
      child: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            cacheEnabled: true,
            supportZoom: false,
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            disableContextMenu: true,
            disableHorizontalScroll: true,
            disableVerticalScroll: true,
            useShouldOverrideUrlLoading: true,
          ),
          android: AndroidInAppWebViewOptions(
            useWideViewPort: false,
          
            // allowContentAccess: true,
            domStorageEnabled: true,
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            sharedCookiesEnabled: true,
            allowsInlineMediaPlayback: true,
            allowsAirPlayForMediaPlayback: true,
            allowsPictureInPictureMediaPlayback: true,
          ),
        ),
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
                  // log('ready_detected');
                  controller!.upDateValue(controller!.value.copyWith(
                    isReady: true,
                  ));
                  controller!.play();
                  //  controller!.setSize(Size(size.width, 300));
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
              handlerName: 'addMetaData',
              callback: (args) {
                controller!.upDateValue(
                  controller!.value
                      .copyWith(youtubeMetaData: YoutubeMetaData.fromRawData(args.first)),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'VideoTime',
              callback: (args) {
                final position = args.first * 1000;
                final num buffered = args.last;
                controller!.upDateValue(
                  controller!.value.copyWith(
                      position: Duration(milliseconds: position.floor()),
                      bufferdPosition: Duration(milliseconds: buffered.floor())),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'addMute',
              callback: (args) {
                controller!.upDateValue(controller!.value.copyWith(muted: true));
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'addUnMute',
              callback: (args) {
                controller!.upDateValue(controller!.value.copyWith(
                  muted: false,
                ));
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'addCurrentTime',
              callback: (args) {
                controller!.upDateValue(controller!.value.copyWith(
                  currentPosition: args.first as double,
                ));
              },
            );
        },
      ),
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
        html,
        body{
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
                pointer-events: none;
              
        }
        </style>
         <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
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
            height: '100%',
            width: '100%',
            videoId: '${controller?.videoId}', // youtube video id
            playerVars: {
                'playsinline': 1,
                'controls': 0,
                'enablejsapi': 1,
                'fs': 0,
                'rel': 0,
                'showinfo': 0,
                'autoplay': 0,
                'iv_load_policy': 3,
                'modestbranding': 1,
            },
            events: {
                onReady: function(event){window.flutter_inappwebview.callHandler('ready');},
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
                window.flutter_inappwebview.callHandler('addMetaData', videoData);
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                    window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime(), player.getVideoLoadedFraction());
                }, 100);
            }

            function setPlaybackRate(rate) {
                player.setPlaybackRate(rate);
                return '';
            } 

           function loadById(loadSettings) {
                player.loadVideoById(loadSettings);
                return '';
            }
             function play() {
                player.playVideo();
                return '';
            }

              function getCurrentTime() {
              var time = player.getCurrentTime();
              window.flutter_inappwebview.callHandler('addCurrentTime', time);
              return '';
            }

           

            function pause() {
                player.pauseVideo();
                return '';
            }

             function mute() {
                player.mute();
                 window.flutter_inappwebview.callHandler('addMute', true);
                return '';
            }

            function unMute() {
                player.unMute();
                 window.flutter_inappwebview.callHandler('addUnMute' , false);
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
            function setPlaybackQuality(playbackQuality) {
             if (playbackQuality == "auto") {
             //this will make quality auto
             window.localStorage.removeItem("yt-player-quality");
                } else  {
                var now = Date.now();
             
               window.localStorage.setItem("yt-player-quality", JSON.stringify({
                data: playbackQuality,
                creation: now,
                expiration: now + 2419200000
              })
              );
           }
          
            if (player) {
            var currentTime = player.getCurrentTime();
            player.loadVideoById(player.getVideoData().video_id, currentTime);
              }
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

    }
</script>
</html>
 ''';
}
