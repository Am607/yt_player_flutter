
// current state of the player
enum PlayerState {
  /// -1 (unstarted)
  unstarted,

  /// 0 (playing)
  playing,

  /// 1 (buffering)
  buffering,

  /// 2 (paused)
  paused,

  /// 3 (ended)
  ended,

  /// 4 (video cued).
  videoCued,
 
 /// not loaded the player
  unknown
}
