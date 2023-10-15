import 'package:flutter/material.dart';
import 'package:apple_todo/models/event_time_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Map<String, String>> _items = [];
  List<EventTime> eventData = [];
  ImageProvider? gambar;

  bool isDark = false;
  get getIsDark => isDark;
  get getGambar => gambar;

  List<Map<String, String>> filteredItems(String filter, bool isDone) {
    if (filter == "") {
      return _items.where((item) => item['isDone'] == isDone.toString()).toList();
    } else {
      return _items.where((item) => item['kategori'] == filter && item['isDone'] == isDone.toString()).toList();
    }
  }

  List<EventTime> events() {
    return eventData;
  }

  set setAllTodo(List<Map<String, String>> data) {
    _items = data;
    notifyListeners();
  }

  set isiTodo(val) {
    _items.add(val);
    notifyListeners();
  }

  set setAllEvent(List<EventTime> data) {
    eventData = data;
    notifyListeners();
  }

  set isiEvent(val) {
    eventData.add(val);
    notifyListeners();
  }

  set hapusEvent(val) {
    eventData.remove(val);
    notifyListeners();
  }

  void deleteAllEvent() {
    eventData = [];
    notifyListeners();
  }

  set setDark(val) {
    isDark = val;
    notifyListeners();
  }

  set setGambar(val) {
    gambar = val;
    notifyListeners();
  }

  void updateTodo(String id, Map<String, String> dataMap) {
    _items = _items.map((item) {
      if (item['id'] == id) {
        return {...dataMap, 'id': id};
      }
      return item;
    }).toList();
    notifyListeners();
  }

  void deleteTodo(String id) {
    _items = _items.where((item) => item['id'] != id.toString()).toList();
    notifyListeners();
  }

  void deleteAllTodo() {
    _items = [];
    notifyListeners();
  }
}
