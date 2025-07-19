class PixabayResponse {
  final int total;
  final int totalHits;
  final List<PixabayImage> hits;

  PixabayResponse({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayResponse.fromJson(Map<String, dynamic> json) {
    var hitsList = json['hits'] as List;
    List<PixabayImage> imagesList = hitsList
        .map((i) => PixabayImage.fromJson(i))
        .toList();

    return PixabayResponse(
      total: json['total'] as int,
      totalHits: json['totalHits'] as int,
      hits: imagesList,
    );
  }
}

class PixabayImage {
  final int id;
  final String pageURL;
  final String type;
  final List<String> tags;

  final String previewURL;
  final int previewWidth;
  final int previewHeight;

  final String webformatURL;
  final int webformatWidth;
  final int webformatHeight;

  final String largeImageURL;
  final int imageWidth;
  final int imageHeight;

  final int imageSize;

  final int views;
  final int downloads;
  final int collections;
  final int likes;
  final int comments;

  final int userId;
  final String user;
  final String userImageURL;
  final String userURL;

  final bool noAiTraining;
  final bool isAiGenerated;
  final bool isGRated;

  final int isLowQuality;

  PixabayImage({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatURL,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageURL,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageURL,
    required this.userURL,
    required this.noAiTraining,
    required this.isAiGenerated,
    required this.isGRated,
    required this.isLowQuality,
  });

  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    List<String> tagsList = (json['tags'] as String)
        .split(',')
        .map((tag) => tag.trim())
        .toList();

    return PixabayImage(
      id: json['id'] as int,
      pageURL: json['pageURL'] as String,
      type: json['type'] as String,
      tags: tagsList,
      previewURL: json['previewURL'] as String,
      previewWidth: json['previewWidth'] as int,
      previewHeight: json['previewHeight'] as int,
      webformatURL: json['webformatURL'] as String,
      webformatWidth: json['webformatWidth'] as int,
      webformatHeight: json['webformatHeight'] as int,
      largeImageURL: json['largeImageURL'] as String,
      imageWidth: json['imageWidth'] as int,
      imageHeight: json['imageHeight'] as int,
      imageSize: json['imageSize'] as int,
      views: json['views'] as int,
      downloads: json['downloads'] as int,
      collections: json['collections'] as int,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      userId: json['user_id'] as int,
      user: json['user'] as String,
      userImageURL: json['userImageURL'] as String,
      userURL: json['userURL'] as String,

      noAiTraining: json['noAiTraining'] == 1,
      isAiGenerated: json['isAiGenerated'] == 1,
      isGRated: json['isGRated'] == 1,
      isLowQuality: json['isLowQuality'] as int,
    );
  }
}
