import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yt_player/src/enum/player_state.dart';

/// [ValueNotifier] for [YtController]
/// define a class to hold the value of the player
class YtPlayerValue {
  YtPlayerValue({
    this.isReady = false,
    this.webViewController,
    this.bufferdPosition = Duration.zero,
    this.position = const Duration(),
    this.errorCode = 0,
    this.hasPlayed = false,
    this.isControllerVisible = false,
    this.isPaused = false,
    this.isPlaying = false,
    this.playerState = PlayerState.unstarted,
    this.volume = 100,
    this.quality,
  });

  /// Return true if the player is ready
  final bool isReady;

  /// whter controller visible or not
  final bool isControllerVisible;

  /// Retrun true if the player once played for the first time
  final bool hasPlayed;

  /// Current position of the video
  final Duration position;

  /// Position up to which the video is bufferd
  final Duration bufferdPosition;

  /// Return true while the video is playing
  final bool isPlaying;

  /// Return true if the video is paused
  final bool isPaused;

  // Volume of the player
  final int volume;

  // Current playerQuality
  final String? quality;

  // Error code
  final int errorCode;

  // Current state of the player
  final PlayerState playerState;

  /// Return true if video is full Screen mode

  /// Reports the [WebViewController].
  final InAppWebViewController? webViewController;

  YtPlayerValue copyWith({
    bool? isReady,
    InAppWebViewController? webViewController,
    PlayerState? playerState,
    bool? isControllerVisible,
    bool? hasPlayed,
    Duration? position,
    Duration? bufferdPosition,
    bool? isPlaying,
    bool? isPaused,
    int? volume,
    String? quality,
    int? errorCode,
  }) {
    return YtPlayerValue(
      isReady: isReady ?? this.isReady,
      webViewController: webViewController ?? this.webViewController,
      playerState: playerState ?? this.playerState,
      isControllerVisible: isControllerVisible ?? this.isControllerVisible,
      hasPlayed: hasPlayed ?? this.hasPlayed,
      position: position ?? this.position,
      bufferdPosition: bufferdPosition ?? this.bufferdPosition,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      volume: volume ?? this.volume,
      quality: quality ?? this.quality,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isReady: $isReady, '
        'isControllerVisible: $isControllerVisible, '
        'position: $position, '
        'bufferdPosition: $bufferdPosition, '
        'isPlaying: $isPlaying, '
        'isPaused: $isPaused, '
        'volume: $volume, '
        'quality: $quality, '
        'playerState: $playerState, '
        'errorCode: $errorCode, '
        'hasPlayed: $hasPlayed, '
        'quality: $quality, ';
         
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
    final inherited = context.dependOnInheritedWidgetOfExactType<InheritedYtPlayer>();
    assert(inherited != null, 'No YtController found in context');
    return inherited?.controller;

    // return context.dependOnInheritedWidgetOfExactType<InheritedYtPlayer>()?.controller;
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
    _nativeCall('loadById({$loadParams})');
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
  void seekTo(Duration d) => _nativeCall('seekTo(${d.inSeconds})');

  /// set the volume of the video
  void setVolume(int volume) => _nativeCall('setVolume($volume)');

  /// setPlayBackRate
  void setPlayBackRate(double rate) => _nativeCall('setPlaybackRate($rate)');

  /// set quality of the video
  void setQuality(String quality) {
    _nativeCall('setPlaybackQuality("$quality")');
    log('setQuality("$quality")');
  }
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
