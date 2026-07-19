import 'package:flutter/material.dart';

class SearchService extends ChangeNotifier {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  String _query = '';
  String get query => _query;

  void setQuery(String value) {
    if (value != _query) {
      _query = value;
      notifyListeners();
    }
  }

  void clear() {
    if (_query.isNotEmpty) {
      _query = '';
      notifyListeners();
    }
  }
}
