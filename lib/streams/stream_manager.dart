import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/models/database_manager.dart';

class StreamManager {
  late DBManager _dbManager;
  late StreamController _controller;
  late StreamSubscription _streamSubscription;

  StreamManager(BuildContext context) {
    final prov = Provider.of<TodoProvider>(context, listen: false);

    _dbManager = DBManager();
    _controller = StreamController();

    _streamSubscription = _controller.stream.listen((data) async {
      var newData = {
        'title': data['title'] as String,
        'keterangan': data['keterangan'] as String,
        'mulai': data['mulai'] as String,
        'selesai': data['selesai'] as String,
        'isDisplayed': data['isDisplayed'] as String,
        'isDone': data['isDone'] as String,
        'kategori': data['kategori'] as String,
        'color': data['color'] as String
      };

      int id = await _dbManager.insertTodo(newData);
      newData['id'] = id.toString();
      prov.isiTodo = newData;
    });
  }

  void add(value) {
    _controller.add(value);
  }

  void cancel() {
    _streamSubscription.cancel();
  }
}
