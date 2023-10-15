class EventTime {
  String id = "";
  String title = "";
  String subtitle = "";
  String startDate = "";
  String endDate = "";

  EventTime(this.title, this.subtitle, this.startDate, this.endDate);

  Map<String, String> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
