import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/favorites/favorite.dart';
import 'package:zest/app/favorites/recently_viewed.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/shared/provider.dart';

abstract class FavoriteItem {
  final UuidValue resourceId;
  final UuidValue companyId;
  final DateTime dateTime;
  final UuidValue? fromDeckId;

  FavoriteItem(this.resourceId, this.companyId, this.dateTime, this.fromDeckId);
}

class FavoritesProvider with ChangeNotifier, Disposable {
  FavoritesProvider(
    this._auth,
    FavoritesProvider? previous,
  ) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _favoriteData = previous!._favoriteData;
      _recentlyViewedData = previous._recentlyViewedData;
      _initComplete = true;
    }
  }

  bool get initComplete => _initComplete;
  List<Favorite>? get favorites => _favoriteData?.values.toList(growable: false)
    ?..sort(((b, a) => a.dateTime.compareTo(b.dateTime)));
  List<RecentlyViewed>? get recentlyViewed =>
      _recentlyViewedData?.values.toList(growable: false)
        ?..sort(((b, a) => a.dateTime.compareTo(b.dateTime)));

  final AuthProvider? _auth;
  bool _initComplete = false;

  static const _favoriteBox = 'favorite';
  Box<Favorite>? _favoriteData;
  static const _recentlyViewedBox = 'recentlyViewed';
  Box<RecentlyViewed>? _recentlyViewedData;

  Future<void> addFavorite(
    Resource resource,
    UuidValue companyId,
    UuidValue? fromDeckId,
  ) async {
    await _favoriteData?.put(
        resource.id.toString(),
        Favorite(
          resource.id,
          companyId,
          DateTime.now().toUtc(),
          fromDeckId,
        ));
    notifyListenersIfNotDisposed();
  }

  Future<void> removeFavorite(Resource resource) async {
    await _favoriteData?.delete(resource.id.toString());
    notifyListenersIfNotDisposed();
  }

  bool isFavorite(Resource resource) {
    return _favoriteData?.containsKey(resource.id.toString()) ?? false;
  }

  Future<void> addRecentlyViewed(
    Resource resource,
    UuidValue companyId,
    UuidValue? fromDeckId,
  ) async {
    await _recentlyViewedData?.put(
        resource.id.toString(),
        RecentlyViewed(
          resource.id,
          companyId,
          DateTime.now().toUtc(),
          fromDeckId,
        ));
    notifyListenersIfNotDisposed();
  }

  Future<void> _init() async {
    if (_auth != null) {
      final dir = await _auth!.getDataDirectory();
      if (dir != null) {
        _favoriteData = await Hive.openBox<Favorite>(
          _favoriteBox,
          path: dir,
        );
        _recentlyViewedData = await Hive.openBox<RecentlyViewed>(
          _recentlyViewedBox,
          path: dir,
        );
        _initComplete = true;
        notifyListenersIfNotDisposed();
      }
    }
  }
}
