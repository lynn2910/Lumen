import 'package:isar/isar.dart';

part 'favorite.g.dart';

@collection
class FavoriteItem {
  Id id = Isar.autoIncrement;

  @Name('image_id')
  late int imageId;

  late List<String> tags;
  late int width;
  late int height;

  @Name('page_url')
  late String pageURL;
  @Name('image_url')
  late String imageURL;

  @Name('is_low_quality')
  late int isLowQuality;

  @Name('is_ai_generated')
  late bool isAiGenerated;

  @Name("added_time")
  late DateTime added;

  FavoriteItem({
    required this.imageId,
    required this.tags,
    required this.pageURL,
    required this.imageURL,
    required this.isLowQuality,
    required this.isAiGenerated,
    required this.added,
    required this.width,
    required this.height,
  });
}
