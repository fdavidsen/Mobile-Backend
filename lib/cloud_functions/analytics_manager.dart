import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsManager {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> testEventLog(value) async {
    await analytics.logEvent(name: '${value}_click', parameters: {'Value': value});
    print('Send Event');
  }
}
