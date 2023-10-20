import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/models/concert_model.dart';
import 'package:apple_todo/screens/concert/concert_detail.dart';

class MyConcert extends StatefulWidget {
  const MyConcert({super.key});

  @override
  State<MyConcert> createState() => _MyConcertState();
}

class _MyConcertState extends State<MyConcert> {
  final String _apiUrl = 'https://raw.githubusercontent.com/fdavidsen/Mobile-Backend/master/lib/events.json';
  List? concertList;
  List? filteredList;

  Future<List?> getConcertData() async {
    http.Response result = await http.get(Uri.parse(_apiUrl));

    if (result.statusCode == HttpStatus.ok) {
      var responseBody = json.decode(result.body);
      var data = responseBody['data'];
      return data.map((e) => Concert.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> loadData() async {
    concertList = await getConcertData();
    setState(() {
      filteredList = concertList;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 50),
      child: ListView.builder(
          itemCount: filteredList?.length == null ? 0 : filteredList?.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 18),
                  color: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                  child: ListTile(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(builder: (_) => ConcertDetail(concert: filteredList![index]));
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(backgroundImage: NetworkImage(filteredList![index].thumbnail)),
                    title: Text(
                      filteredList![index].name,
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      'Subtype: ${filteredList![index].subtype} - Rating: ${filteredList![index].rating}',
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
