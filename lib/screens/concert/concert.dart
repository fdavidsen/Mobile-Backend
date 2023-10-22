import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:apple_todo/utilities/constants.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/models/concert_model.dart';
import 'package:apple_todo/screens/concert/concert_detail.dart';

class MyConcert extends StatefulWidget {
  const MyConcert({super.key});

  @override
  State<MyConcert> createState() => _MyConcertState();
}

class _MyConcertState extends State<MyConcert> {
  List? concertList;
  List? filteredList;

  List<String> options = [
    'No Filter',
    'Live Music Venue',
    'Concert Hall',
    'Arena',
  ];
  String selectedOption = 'No Filter';
  String searchQuery = '';

  final _searchController = TextEditingController();

  Future<List?> getConcertData() async {
    http.Response result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == HttpStatus.ok) {
      var responseBody = json.decode(result.body);
      var data = responseBody['data'];
      return data.map((e) => Concert.fromJson(e)).toList();
    }
    return null;
  }

  void filterResults(String query) {
    searchQuery = query;
    List filterResults = concertList!
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) && (selectedOption != 'No Filter' ? item.subtype.contains(selectedOption) : true))
        .toList();
    setState(() {
      filteredList = filterResults;
    });
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
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: filterResults,
            decoration: InputDecoration(
              hintText: "Cari nama konser",
              prefixIcon: Icon(Icons.search, color: context.watch<TodoProvider>().isDark ? Colors.blue : Colors.grey[500]),
              hintStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.blue : const Color(0xff1e1e1e)),
            ),
            style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.blue : const Color(0xff1e1e1e)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: options.map((option) {
                  return ChoiceChip(
                    label: Text(
                      option,
                      style: TextStyle(color: selectedOption == option ? Colors.white : Colors.blue),
                    ),
                    selected: selectedOption == option,
                    selectedColor: Colors.blue,
                    backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedOption = selected ? option : '';
                        filterResults(searchQuery);
                      });
                    },
                  );
                }).toList()),
          ),
          Expanded(
            child: filteredList?.length != null && filteredList?.length != 0
                ? ListView.builder(
                    itemCount: filteredList?.length,
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
                    })
                : Column(
                    children: [
                      Container(width: 200, margin: const EdgeInsets.only(bottom: 10), child: Image.asset('assets/no-concert.png')),
                      Text('Tidak ada konser',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black))
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
