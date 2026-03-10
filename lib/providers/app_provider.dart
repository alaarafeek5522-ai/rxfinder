import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';

class AppProvider extends ChangeNotifier {
  bool _isDark = false;
  List<Medicine> _favorites = [];
  List<String> _recentSearches = [];

  bool get isDark => _isDark;
  List<Medicine> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('dark_mode') ?? false;
    final favList = prefs.getStringList('favorites') ?? [];
    _favorites = favList.map((e) {
      final map = json.decode(e) as Map<String, dynamic>;
      return Medicine.fromSearchJson(map);
    }).toList();
    _recentSearches = prefs.getStringList('recent_searches') ?? [];
    notifyListeners();
  }

  void toggleDark() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDark);
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((m) => m.id == id);

  Future<void> toggleFavorite(Medicine medicine) async {
    final prefs = await SharedPreferences.getInstance();
    if (isFavorite(medicine.id)) {
      _favorites.removeWhere((m) => m.id == medicine.id);
    } else {
      _favorites.add(medicine);
    }
    await prefs.setStringList(
      'favorites',
      _favorites.map((m) => json.encode(m.toJson())).toList(),
    );
    notifyListeners();
  }

  Future<void> addRecentSearch(String query) async {
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) _recentSearches.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', []);
    notifyListeners();
  }
}
