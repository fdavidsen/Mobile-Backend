import 'package:flutter/material.dart';

class ConcertProvider extends ChangeNotifier {
  List? _concertList;
  List? _filteredList;

  get concertList => _concertList;
  set concertList(value) {
    _concertList = value;
    _filteredList = value;
    notifyListeners();
  }

  get filteredList => _filteredList;
  set filteredList(value) {
    _filteredList = value;
    notifyListeners();
  }
}
