import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class MemberDetail extends StatefulWidget {
  const MemberDetail({super.key, required this.member});

  final Map member;

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member['name']),
        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.blue,
      ),
      body: Container(
        color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 75),
          child: Column(
            children: [
              Image.asset('assets/about/${widget.member['picture']}'),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 40, bottom: 15),
                child: Text(widget.member['nim'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 35),
                child: Text(widget.member['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Text(widget.member['quote'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
