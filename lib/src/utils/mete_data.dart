
/// Metadata of the currently loaded Youtube video.
class YoutubeMetaData {
  /// Youtube video ID of the currently loaded video.
  final String videoId;

  /// Video title of the currently loaded video.
  final String videoTitle;

  /// Channel name or uploader of the currently loaded video.
  final String authorName;

  /// Total duration of the currently loaded video.
  final Duration duration;

  /// Creates [YoutubeMetaData] for Youtube Video.
  const YoutubeMetaData({
    this.videoId = '',
    this.videoTitle = '',
    this.authorName = '',
    this.duration = const Duration(),
  });

  /// [YoutubeMetaData] for the currently loaded video. 
  factory YoutubeMetaData.fromRawData(dynamic rawData) {
    final data = rawData as Map<String, dynamic>;
    final durationInMs = ((data['duration'] ?? 0).toDouble() * 1000).floor();
    return YoutubeMetaData(
      videoId: data['videoId'],
      videoTitle: data['title'],
      authorName: data['author'],
      duration: Duration(milliseconds: durationInMs),
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'title: $videoTitle, '
        'author: $authorName, '
        'duration: ${duration.inSeconds} sec.)';
  }
}