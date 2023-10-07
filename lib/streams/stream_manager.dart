import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class StreamManager {
  late StreamController _controller;
  late StreamSubscription _streamSubscription;

  StreamManager(BuildContext context) {
    final prov = Provider.of<TodoProvider>(context, listen: false);

    _controller = StreamController();
    _streamSubscription = _controller.stream.listen((data) {
      prov.isiTodo = {
        'title': data['title'].toString(),
        'keterangan': data['keterangan'].toString(),
        'mulai': data['mulai'].toString(),
        'selesai': data['selesai'].toString(),
        'isDisplayed': data['isDisplayed'].toString(),
        'isDone': data['isDone'].toString(),
        'kategori': data['kategori'].toString(),
        'color': data['color'].toString()
      };
    });
  }

  void add(value) {
    _controller.add(value);
  }

  void cancel() {
    _streamSubscription.cancel();
  }
}
