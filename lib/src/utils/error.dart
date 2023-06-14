String errorString(int errorCode) {
  switch (errorCode) {
    case 1:
      return 'Invalid video ID';
    case 2:
      return 'The request contain invalid parameters';
    case 5:
      return 'The requested content cannot be played by this player';
    case 100:
      return 'The video requested was not found';
    case 101:
      return 'The video is desabled by video owner';
    case 105:
      return 'Exact error cannot be determined for this video.';
    case 150:
      return 'The video owner does not allow the video to be played in embedded players';
    default:
      return 'Unknown error';
  }
}
// this error code and message is referenced from the flutter iframe player package
// https://pub.dev/packages/flutter_iframe_player