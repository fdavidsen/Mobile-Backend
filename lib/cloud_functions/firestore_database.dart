import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apple_todo/models/event_time_model.dart';

class FSDatabase {
  late FirebaseFirestore _database;
  final String _collection_event = 'event';

  Future<EventTime> insertEvent(EventTime data) async {
    _database = await FirebaseFirestore.instance;

    var result = await _database.collection(_collection_event).add(data.toMap());
    data.id = result.id;

    return data;
  }

  Future<List<EventTime>> getAllEvent() async {
    _database = await FirebaseFirestore.instance;

    var result = await _database.collection(_collection_event).orderBy('end_date', descending: true).get();
    return result.docs.map((doc) => EventTime.fromDocSnapshot(doc)).toList();
  }

  Future<void> deleteEvent(String id) async {
    _database = await FirebaseFirestore.instance;

    await _database.collection(_collection_event).doc(id).delete();
  }

  Future<void> deleteAllEvent() async {
    _database = await FirebaseFirestore.instance;

    await _database.collection(_collection_event).get().then((res) {
      for (var element in res.docs) {
        element.reference.delete();
      }
    });
  }

  Future<void> toggleEventPassStatus(EventTime event) async {
    _database = await FirebaseFirestore.instance;

    await _database.collection(_collection_event).doc(event.id).update({'is_passed': !event.isPassed});
  }
}
