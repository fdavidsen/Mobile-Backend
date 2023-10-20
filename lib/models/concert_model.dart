import 'package:apple_todo/utilities/constants.dart';

class Concert {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final String link;
  final String startTime;
  final String endTime;
  final String subtype;
  final double rating;

  Concert(
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.link,
    this.startTime,
    this.endTime,
    this.subtype,
    this.rating,
  );

  factory Concert.fromJson(Map<String, dynamic> parsedJson) {
    final id = parsedJson['event_id'];
    final name = parsedJson['name'];
    final description = parsedJson['description'];
    final thumbnail = parsedJson['thumbnail'] ?? defaultConcertThumbnail;
    final link = parsedJson['link'] ?? '';
    final startTime = parsedJson['start_time'];
    final endTime = parsedJson['end_time'];
    final rating = parsedJson['venue']['rating'];

    List<String> subtypeWords = parsedJson['venue']['subtype'].split('_');
    for (int i = 0; i < subtypeWords.length; i++) {
      subtypeWords[i] = subtypeWords[i][0].toUpperCase() + subtypeWords[i].substring(1).toLowerCase();
    }
    final subtype = subtypeWords.join(' ');

    return Concert(
      id,
      name,
      description,
      thumbnail,
      link,
      startTime,
      endTime,
      subtype,
      rating,
    );
  }
}
