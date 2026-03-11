import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine_model.dart';
import '../services/api_service.dart';

enum SearchState { idle, loading, success, error }

class MedicineProvider with ChangeNotifier {
  List<Medicine> _results = [];
  List<Medicine> _favorites = [];
  List<String> _recentSearches = [];
  SearchState _state = SearchState.idle;
  String _errorMessage = '';
  Medicine? _selectedMedicine;
  bool _isLoadingInfo = false;

  List<Medicine> get results => _results;
  List<Medicine> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;
  SearchState get state => _state;
  String get errorMessage => _errorMessage;
  Medicine? get selectedMedicine => _selectedMedicine;
  bool get isLoadingInfo => _isLoadingInfo;

  MedicineProvider() {
    _loadFavorites();
    _loadRecentSearches();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    _state = SearchState.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      _results = await ApiService.searchMedicine(query.trim());
      _state = SearchState.success;
      _addRecentSearch(query.trim());
    } catch (e) {
      _state = SearchState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _results = [];
    }
    notifyListeners();
  }

  Future<void> loadMedicineInfo(Medicine medicine) async {
    _isLoadingInfo = true;
    _selectedMedicine = medicine;
    notifyListeners();
    try {
      _selectedMedicine = await ApiService.getMedicineInfo(medicine.id, medicine);
    } catch (_) {
      _selectedMedicine = medicine;
    }
    _isLoadingInfo = false;
    notifyListeners();
  }

  void clearResults() {
    _results = [];
    _state = SearchState.idle;
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((m) => m.id == id);

  void toggleFavorite(Medicine medicine) {
    if (isFavorite(medicine.id)) {
      _favorites.removeWhere((m) => m.id == medicine.id);
    } else {
      _favorites.add(medicine);
    }
    _saveFavorites();
    notifyListeners();
  }

  void _addRecentSearch(String query) {
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    _saveRecentSearches();
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _saveRecentSearches();
    notifyListeners();
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    _saveRecentSearches();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorites') ?? [];
    _favorites = data.map((e) => Medicine.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favorites', _favorites.map((m) => jsonEncode(m.toJson())).toList());
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches = prefs.getStringList('recent_searches') ?? [];
    notifyListeners();
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }
}
