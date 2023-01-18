import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yt_player/src/enum/player_state.dart';
import 'package:yt_player/src/utils/mete_data.dart';
import 'package:yt_player/src/widget/yt_player.dart';

/// [ValueNotifier] for [YtController]
/// define a class to hold the value of the player
/// current positon and currentPostion both are now an expirimental
/// the player is not stabel and will have more issue in production
class YtPlayerValue {
  YtPlayerValue({
    this.isReady = false,
    this.webViewController,
    this.bufferdPosition = Duration.zero,
    this.position = const Duration(),
    this.currentPosition = 0.0,
    this.errorCode = 0,
    this.hasPlayed = false,
    this.isControllerVisible = false,
    this.isPaused = false,
    this.isPlaying = false,
    this.playerState = PlayerState.unstarted,
    this.volume = 100,
    this.quality,
    this.isFullScreen = false,
    this.muted = false,
    this.youtubeMetaData = const YoutubeMetaData(),
  });

  // meta Data for current playing video
  final YoutubeMetaData youtubeMetaData;

  /// Return true if the player is ready
  final bool isReady;

  /// whter controller visible or not
  final bool isControllerVisible;

  /// Retrun true if the player once played for the first time
  final bool hasPlayed;

  /// Current position of the video
  final Duration position;

  /// Current position of the videofor seek
  double? currentPosition;

  /// Position up to which the video is bufferd
  final Duration bufferdPosition;

  /// return true if player is muted
  final bool muted;

  /// Return true while the video is playing
  final bool isPlaying;

  /// Return true if the video is paused
  final bool isPaused;

  /// Volume of the player
  final int volume;

  /// Current playerQuality
  final String? quality;

  /// Error code
  final int errorCode;

  /// Current state of the player
  final PlayerState playerState;

  /// is the player full screen
  final bool isFullScreen;

  /// Return true if video is full Screen mode

  /// Reports the [WebViewController].
  final InAppWebViewController? webViewController;

  YtPlayerValue copyWith(
      {bool? isReady,
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
      double? currentPosition,
      bool? muted,
      bool? isFullScreen,
      YoutubeMetaData? youtubeMetaData}) {
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
      muted: muted ?? this.muted,
      quality: quality ?? this.quality,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      currentPosition: currentPosition ?? this.currentPosition,
      errorCode: errorCode ?? this.errorCode,
      youtubeMetaData: youtubeMetaData ?? this.youtubeMetaData,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'youtubeMetaData: ${youtubeMetaData.toString()}, '
        'isReady: $isReady, '
        'isControllerVisible: $isControllerVisible, '
        'position: $position, '
        'currentPosition: $currentPosition, '
        'bufferdPosition: $bufferdPosition, '
        'isPlaying: $isPlaying, '
        'isPaused: $isPaused, '
        'volume: $volume, '
        'quality: $quality, '
        'playerState: $playerState, '
        'errorCode: $errorCode, '
        'hasPlayed: $hasPlayed, '
        'muted: $muted, '
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
      // log('not ready');
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

  /// set width
  void setSize(Size size) {
    var adjustedHeight = 9 / 16 * size.width;
    _nativeCall('setSize(${size.width}, $adjustedHeight)');
  }

  /// seek to a specific time
  void seekTo(Duration d) => _nativeCall('seekTo(${d.inSeconds}, true)');

  /// set the volume of the video
  void setVolume(int volume) => _nativeCall('setVolume($volume)');

  /// setPlayBackRate
  void setPlayBackRate(double rate) => _nativeCall('setPlaybackRate($rate)');

  void changeVideoQuality(String quality) {
    _nativeCall('setPlaybackQuality("$quality")');
    log('changeVideoQuality("$quality")');
  }

  // toogle the play/pause state
  void togglePlayPause() {
    if (value.isPlaying) {
      _nativeCall('pause()');
    } else {
      _nativeCall('play()');
    }
  }

 

  Future<double> get currentTime async {
    await _nativeCall('getCurrentTime');

    return value.currentPosition ?? 0;
  }

  /// Creates a stream that repeatedly emits current time at [period] intervals.
//   Stream<Duration> getCurrentPositionStream({
//     Duration period = const Duration(microseconds: 200),
//   }) async* {
//     yield _getDurationFrom(seconds: await currentTime);
//     // yield value.position;
//
//     yield* Stream.periodic(period).asyncMap(
//       (_) async => _getDurationFrom(seconds: await currentTime),
//       // value.position,
//     );
//   }

  void toggleFullScreenMode(BuildContext context) {
    upDateValue(value.copyWith(isFullScreen: !value.isFullScreen));
    if (value.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Navigator.of(context).push(_createRoute());
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      // Navigator.of(context).pop();
      // Navigator.of(context).didUpdateWidget(Navigator.of(context).widget);

    }
  }

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
  //       body: Container(
  //         color: Colors.black,
  //         child: Center(
  //           child: AspectRatio(
  //             aspectRatio: 16 / 9,
  //             child: YtPlayer(
  //               controller: this,
  //               // onReady: () {
  //               //   log('Player is ready.');
  //               // },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       return child;
  //     },
  //   );
  // }

  Stream<Duration> getCurrentPositionStream({
    Duration period = const Duration(microseconds: 200),
  }) async* {
    yield _getDurationFrom(seconds: await currentTime);
    // yield value.position;

    yield* Stream.periodic(period).asyncMap(
      (_) async => _getDurationFrom(seconds: await currentTime),
      // value.position,
    );
  }

  Duration _getDurationFrom({required double seconds}) {
    final timeInMs = (seconds * 1000).truncate();

    return Duration(milliseconds: timeInMs);
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
