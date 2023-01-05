import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// [ValueNotifier] for [YtController]
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

  YtPlayerValue copyWith({
    bool? isReady,
    InAppWebViewController? webViewController,
  }) {
    return YtPlayerValue(
      isReady: isReady ?? this.isReady,
      webViewController: webViewController ?? this.webViewController,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isReady: $isReady, ';
  }
}

class YtController extends ValueNotifier<YtPlayerValue> {
  /// A controller for [YtPlayer]
  YtController({
    required this.videoId,
    // YtPlayerValue value =  YtPlayerValue(),
  }) : super(YtPlayerValue());

  final String videoId;

  /// find yt_player in provided context

  static YtController? of(BuildContext context) {
    // final inherited = context.dependOnInheritedWidgetOfExactType<InheritedYtPlayer>();
    // assert(inherited != null, 'No YtController found in context');
    // return inherited?.controller;

    return context.dependOnInheritedWidgetOfExactType<InheritedYtPlayer>()?.controller;
  }

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

  void upDateValue(YtPlayerValue newValue) {
    value = newValue;
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

class InheritedYtPlayer extends InheritedWidget {
  const InheritedYtPlayer({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  /// a controller for the player
  final YtController controller;

  @override
  bool updateShouldNotify(InheritedYtPlayer oldWidget) =>
      oldWidget.controller.hashCode != controller.hashCode;
}
