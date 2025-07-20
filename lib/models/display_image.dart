import 'package:lumen/services/favorite.dart';
import 'package:lumen/services/pixabay_image.dart';

class DisplayImage {
  int id;

  String photoUrl;
  String pageUrl;

  int width;
  int height;

  bool isLowQuality;
  bool isAiGenerated;

  List<String> tags;

  DisplayImage({
    required this.id,
    required this.photoUrl,
    required this.pageUrl,
    required this.width,
    required this.height,
    required this.tags,
    required this.isLowQuality,
    required this.isAiGenerated,
  });

  static DisplayImage fromFavoriteImage(FavoriteItem favoriteItem) {
    return DisplayImage(
      id: favoriteItem.imageId,
      photoUrl: favoriteItem.imageURL,
      pageUrl: favoriteItem.pageURL,
      width: favoriteItem.width,
      height: favoriteItem.height,
      tags: favoriteItem.tags,
      isLowQuality: favoriteItem.isLowQuality == 1,
      isAiGenerated: favoriteItem.isAiGenerated,
    );
  }

  static DisplayImage fromPixabayImage(PixabayImage image) {
    return DisplayImage(
      id: image.id,
      photoUrl: image.webformatURL,
      pageUrl: image.pageURL,
      width: image.webformatWidth,
      height: image.webformatHeight,
      tags: image.tags,
      isLowQuality: image.isLowQuality == 1,
      isAiGenerated: image.isAiGenerated,
    );
  }
}
