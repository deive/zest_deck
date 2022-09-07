import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
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
    this._appProvider,
    this._authProvider,
    this._deckListProvider,
    FavoritesProvider? previous,
  ) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _copyInit(previous!);
    }
  }

  bool get initComplete => _initComplete;
  List<Favorite>? get favorites => _favoriteData?.values.toList(growable: false)
    ?..sort(((b, a) => a.dateTime.compareTo(b.dateTime)));
  List<RecentlyViewed>? get recentlyViewed =>
      _recentlyViewedData?.values.toList(growable: false)
        ?..sort(((b, a) => a.dateTime.compareTo(b.dateTime)));

  final AppProvider _appProvider;
  final AuthProvider? _authProvider;
  final DeckListProvider? _deckListProvider;
  bool _initComplete = false;
  String? _lastViewedResourceId;

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
    notifyListeners();
  }

  Future<void> removeFavorite(Resource resource) async {
    await _favoriteData?.delete(resource.id.toString());
    notifyListeners();
  }

  bool isFavorite(Resource resource) {
    return _favoriteData?.containsKey(resource.id.toString()) ?? false;
  }

  Future<void> _init() async {
    if (_authProvider != null) {
      final dir = await _authProvider!.getDataDirectory();
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

  Future<void> _copyInit(FavoritesProvider previous) async {
    _favoriteData = previous._favoriteData;
    _recentlyViewedData = previous._recentlyViewedData;
    final routeResourceId = _appProvider.routeResourceId;
    if (_lastViewedResourceId == null && routeResourceId != null) {
      _addRecentlyViewed();
    } else if (_lastViewedResourceId != null && routeResourceId == null) {
      _lastViewedResourceId = null;
    } else if (_lastViewedResourceId != routeResourceId) {
      _addRecentlyViewed();
    }
    _initComplete = true;
  }

  Future<void> _addRecentlyViewed() async {
    final routeResourceId = _appProvider.routeResourceId;
    if (routeResourceId != null) {
      final r = _deckListProvider?.getResourceById(UuidValue(routeResourceId));
      if (r != null) {
        final resource = r.first;
        final deck = r.second;
        await _recentlyViewedData?.put(
            resource.id.toString(),
            RecentlyViewed(
              resource.id,
              deck.companyId!,
              DateTime.now().toUtc(),
              deck.id,
            ));
        _lastViewedResourceId = routeResourceId;
        notifyListeners();
      }
    }
  }
}
