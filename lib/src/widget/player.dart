//Copyright (c) 2020, the Flutter project authors. Please see the AUTHORS file
//for details. All rights reserved. Use of this source code is governed by a
//BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YtPlayer extends StatelessWidget {
  const YtPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: true,
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(),
              android: AndroidInAppWebViewOptions(
                allowContentAccess: true,
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
                allowsAirPlayForMediaPlayback: true,
                allowsPictureInPictureMediaPlayback: true,
              )),
        ));
  }
}
