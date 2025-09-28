import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteResortIds = [];

  List<String> get favoriteResortIds => _favoriteResortIds;

  FavoriteProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteResortIds = prefs.getStringList('favorite_resorts') ?? [];
    notifyListeners();
  }

  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_resorts', _favoriteResortIds);
  }

  bool isFavorite(String resortId) {
    return _favoriteResortIds.contains(resortId);
  }

  void toggleFavorite(String resortId) {
    if (_favoriteResortIds.contains(resortId)) {
      _favoriteResortIds.remove(resortId);
    } else {
      _favoriteResortIds.add(resortId);
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String resortId) {
    _favoriteResortIds.remove(resortId);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteResortIds.clear();
    _saveFavorites();
    notifyListeners();
  }
}