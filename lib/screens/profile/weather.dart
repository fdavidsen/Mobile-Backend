import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  String city = '';
  String weather = '';
  String temperature = '';
  String humidity = '';
  String wind = '';
  String time = '';

  Future<void> getWeather() async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${_locationData.latitude}&lon=${_locationData.longitude}&appid=903507f17d707fecd352d38301efba77';
    http.Response result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == HttpStatus.ok) {
      var responseBody = json.decode(result.body);

      setState(() {
        city = responseBody['name'].toUpperCase();
        weather = responseBody['weather'][0]['description'];
        temperature = (responseBody['main']['temp'] - 273).toStringAsFixed(2);
        humidity = responseBody['main']['humidity'].toString();
        wind = responseBody['wind']['speed'].toString();
      });
    }
  }

  Future<void> _initLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    time = DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt()));
    await getWeather();
  }

  @override
  void initState() {
    _initLocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return city.isNotEmpty
        ? Card(
            color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    city,
                    style: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '~ $weather ~',
                      style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '$temperature\u00B0',
                        style: TextStyle(
                          color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                          fontSize: 45,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${wind}mph',
                            style: TextStyle(
                              color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$humidity%',
                            style: TextStyle(
                              color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
