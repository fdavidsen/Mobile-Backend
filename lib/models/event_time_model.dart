import 'package:cloud_firestore/cloud_firestore.dart';

class EventTime {
  String id = "";
  String title = "";
  String subtitle = "";
  String startDate = "";
  String endDate = "";
  bool isPassed = false;

  EventTime(this.title, this.subtitle, this.startDate, this.endDate);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'start_date': startDate,
      'end_date': endDate,
      'is_passed': isPassed,
    };
  }

  EventTime.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = doc.data()?['title'],
        subtitle = doc.data()?['subtitle'],
        startDate = doc.data()?['start_date'],
        endDate = doc.data()?['end_date'],
        isPassed = doc.data()?['is_passed'];
}
