import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/models/concert_model.dart';

class ConcertDetail extends StatefulWidget {
  const ConcertDetail({super.key, required this.concert});

  final Concert concert;

  @override
  State<ConcertDetail> createState() => _ConcertDetailState();
}

class _ConcertDetailState extends State<ConcertDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.concert.name),
        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.blue,
      ),
      body: Container(
        color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 75),
          child: Column(
            children: [
              Image.network(widget.concert.thumbnail, width: MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 25),
                child: Text(widget.concert.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event ID: ${widget.concert.id}',
                        style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('Start Time: ${widget.concert.startTime}',
                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    ),
                    Text('End Time: ${widget.concert.endTime}',
                        style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Text(widget.concert.description,
                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    ),
                    widget.concert.link.isNotEmpty
                        ? Text('Link: ${widget.concert.link}',
                            style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black))
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
