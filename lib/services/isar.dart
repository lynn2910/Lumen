import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'favorite.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([FavoriteItemSchema], directory: dir.path);
  }
}
