import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motorsports_calendar/models/motorsport_event.dart';

class EventService {
  Future<List<MotorsportEvent>> fetchEvent(url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map eventData = jsonDecode(response.body);
      List<dynamic> events = [];

      eventData.forEach((key, value) {
        value['events'].forEach((val) {
          val['series'] = key;
          events.add(val);
        });
      });

      return events.map((e) {
        return MotorsportEvent.fromJson(e);
      }).toList();
    } else {
      throw Exception('Failed to load event');
    }
  }
}
