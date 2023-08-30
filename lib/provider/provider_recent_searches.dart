import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluter_tuto/models/model_recent_search.dart';

class RecentSearchesProvider with ChangeNotifier {
  List<RecentSearch> _recentSearches = [];

  List<RecentSearch> get recentSearches => [..._recentSearches];

  void addSearch(RecentSearch search) async {
    _recentSearches.insert(0, search);  // Add new search at the beginning of the list.
    if (_recentSearches.length > 10) {   // Keep only the latest 5 searches.
      _recentSearches.removeAt(10);
    }
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(
      _recentSearches.map((s) => {
        'sourceName': s.sourceName,
        'destinationName': s.destinationName,
        'sourceX': s.sourceX,
        'sourceY': s.sourceY,
        'destinationX': s.destinationX,
        'destinationY': s.destinationY,
      }).toList(),
    );
    await prefs.setString('recentSearches', jsonData);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('recentSearches')) return;

    final jsonData = prefs.getString('recentSearches');
    if (jsonData == null) return; // Handle the case where jsonData is null

    final data = json.decode(jsonData) as List<dynamic>; // Use `dynamic` instead of `List`
    _recentSearches = data.map((item) => RecentSearch(
      sourceName: item['sourceName'],
      destinationName: item['destinationName'],
      sourceX: item['sourceX'],
      sourceY: item['sourceY'],
      destinationX: item['destinationX'],
      destinationY: item['destinationY'],
    )).toList();

    notifyListeners();
  }

}
