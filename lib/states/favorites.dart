import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lumen/services/favorite.dart';

class FavoriteImages extends ChangeNotifier {
  final Isar _isar;
  final List<FavoriteItem> _items = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  UnmodifiableListView<FavoriteItem> get items => UnmodifiableListView(_items);

  FavoriteImages(this._isar) {
    _loadInitialFavorites();
  }

  void add(FavoriteItem item) {
    _items.add(item);
    notifyListeners();
    _addFavoriteImageToDB(item);
  }

  void removeById(int itemId) {
    var index = _items.indexWhere((i) => i.id == itemId);
    if (index < 0) return;

    _items.removeAt(index);
    notifyListeners();
    _removeFavoriteImageToDB(itemId);
  }

  void removeByImageId(int imageId) {
    var index = _items.indexWhere((i) => i.imageId == imageId);
    if (index < 0) return;

    final retValue = _items.removeAt(index);
    notifyListeners();
    _removeFavoriteImageToDB(retValue.id);
  }

  bool isFavorite(int imageId) {
    return _items.any((item) => item.imageId == imageId);
  }

  FavoriteItem? getItemByImageId(int imageId) {
    return _items.firstWhereOrNull((item) => item.imageId == imageId);
  }

  Future<void> _loadInitialFavorites() async {
    _isLoading = true;
    notifyListeners();

    final allFavorites = await _isar.favoriteItems.where().findAll();

    _items.clear();
    _items.addAll(allFavorites);

    _isLoading = false;
    notifyListeners();
  }

  //
  //
  //    DATABASE - (Keep your existing database methods, ensuring they open/close Isar appropriately)
  //
  //

  Future<FavoriteItem?> _getFavoriteItem(int itemId) async {
    final item = await _isar.favoriteItems
        .filter()
        .imageIdEqualTo(itemId)
        .findFirst();

    return item;
  }

  Future<List<FavoriteItem>> _getAllFavoriteItemsFromDB() async {
    final items = await _isar.favoriteItems.where().findAll();
    return items;
  }

  Future<void> _addFavoriteImageToDB(FavoriteItem item) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteItems.put(item);
    });
  }

  Future<void> _removeFavoriteImageToDB(int itemId) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteItems.delete(itemId);
    });
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
