//Copyright (c) 2020, the Flutter project authors. Please see the AUTHORS file
//for details. All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yt_player/yt_player.dart';





class BottomPlayer extends StatefulWidget {

  const BottomPlayer({super.key,});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer>  with WidgetsBindingObserver{
 late YtController ? controller;

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Todo check what happend
  }

   @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Todo check what happend
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // controller =  YtController(videoId: 'NaCM4jWaxk0'); 
    ////! this is the problem 
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

              webController..addJavaScriptHandler(handlerName: 'ready', callback: (_){
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

    onYouTubeIframeAPIReady = function () {
        player = new YT.Player('player', {
            frameborder: "0",
            height: '244',
            width: '434',
            // videoId: '6BX9nCiFd2k?modestbranding=1&autohide=1&quality=low', // youtube video id
            videoId: '${controller?.videoId}', // youtube video id
            playerVars: {
                'playsinline': 1,
                'controls': 1,
                'enablejsapi': 1,
                'fs': 0,
                'rel': 0,
                'showinfo': 0,
                'autoplay': 0,
            },
            events: {
                // 'onStateChange': onPlayerStateChange,
               'onReady': function(event){window.flutter_inappwebview.callHandler('ready');}
                

            }
        });

    }

  function loadById(loadSettings) {
                player.loadVideoById(loadSettings);
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
     
    }
</script>
</html>
 ''';
}
