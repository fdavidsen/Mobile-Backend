import 'package:flutter/material.dart';

class EventTime{
  String title = "";
  String subtitle = "";
  String startDate = "";
  String endDate = "";

  EventTime(this.title, this.subtitle, this.startDate, this.endDate);
}

class TodoProvider extends ChangeNotifier{
  final List<Map<String, String>> _items = [];
  List<EventTime> eventData = [];
  ImageProvider? gambar;

  bool isDark = false;
  get getIsDark => isDark;
  get getGambar => gambar;

  List<Map<String, String>> filteredItems(String filter, bool isDone) {
    if(filter == ""){
      return _items.where((item) => item['isDone'] == isDone.toString()).toList();
    }
    else {
      return _items.where((item) => item['kategori'] == filter && item['isDone'] == isDone.toString()).toList();
    }
  }

  List<EventTime> events(){
    return eventData;
  }

  set isiTodo(val){
    _items.add(val);
    notifyListeners();
  }

  set isiEvent(val){
    eventData.add(val);
    notifyListeners();
  }

  set hapusEvent(val){
    eventData.remove(val);
    notifyListeners();
  }

  set setDark(val){
    isDark = val;
    notifyListeners();
  }

  set setGambar(val){
    gambar = val;
    notifyListeners();
  }
}