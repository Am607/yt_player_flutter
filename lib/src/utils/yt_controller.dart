import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// define a class to hold the value of the player
class YtPlayerValue {
  YtPlayerValue({
    this.isReady = false,
    this.webViewController,
  });

  /// return true if the player is ready
  final bool isReady;

  /// Reports the [WebViewController].
  final InAppWebViewController? webViewController;
}

class YtController extends ValueNotifier<YtPlayerValue> {
  /// A controller for [YtPlayer]
  YtController({
    required this.videoId,
  }) : super(YtPlayerValue());

  final String videoId;
  // final InAppWebViewController webViewController = InAppWebViewController('' ,);
  /// call the native method by using the webview controller
  /// linking the javascript code to the dart code
  /// for more details visit: https://pub.dev/packages/flutter_inappwebview
  _nativeCall(String js) async {
    if (value.isReady) {
      await value.webViewController?.evaluateJavascript(source: js);
    } else {
      log('not ready');
    }
  }

  /// load the video
  void load(String videoId, {int startAt = 0}) {
    var loadParams = 'videoId:"$videoId",startSeconds:$startAt';
    _nativeCall('loadBy({$loadParams})');
  }

  /// play the video
  void play() => _nativeCall('play()');

  /// pause the video
  void pause() => _nativeCall('pause()');

  /// stop the video
  void stop() => _nativeCall('stop()');

  /// mute the video
  void mute() => _nativeCall('mute()');

  /// unmute the video
  void unMute() => _nativeCall('unMute()');

  /// seek to a specific time
  void seekTo(int seconds) => _nativeCall('seekTo($seconds)');

  /// set the volume of the video
  void setVolume(int volume) => _nativeCall('setVolume($volume)');
}
