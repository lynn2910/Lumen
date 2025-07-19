import 'package:isar/isar.dart';

part 'favorite.g.dart';

@collection
class FavoriteItem {
  Id id = Isar.autoIncrement;

  @Name('image_id')
  late int imageId;

  late List<String> tags;

  @Name('page_url')
  late String pageURL;

  @Name('is_low_quality')
  late int isLowQuality;

  @Name('is_ai_generated')
  late bool isAiGenerated;

  FavoriteItem({
    required this.imageId,
    required this.tags,
    required this.pageURL,
    required this.isLowQuality,
    required this.isAiGenerated,
  });
}
