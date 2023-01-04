//Copyright (c) 2020, the Flutter project authors. Please see the AUTHORS file
//for details. All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YtPlayer extends StatelessWidget {
  /// A widget that displays a YouTube video.
  const YtPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
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
            videoId: '6BX9nCiFd2k', // youtube video id
            playerVars: {
                'playsinline': 1,
                'controls': 0,
                'enablejsapi': 1,
                'fs': 0,
                'rel': 0,
                'showinfo': 0,
                'autoplay': 0,
            },
            events: {
                // 'onStateChange': onPlayerStateChange,
                // 'onReady': hideVideoTitle(),
                

            }
        });

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

// 
//   onPlayerStateChange = function (event) {
//         if (event.data == YT.PlayerState.ENDED) {
//             $('.start-video').fadeIn('normal');
//         }
//     }

    // $(document).on('click', '.start-video', function () {
    //     $(this).fadeOut('normal');
    //     player.playVideo();
    // });