import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:motorsports_calendar/models/motorsport_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final f1jsonurl = 'https://jsonkeeper.com/b/QYKE';

  List<MotorsportEvent> f1Data = [];

  getEvents() async {
    f1Data = await fetchEvent(f1jsonurl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getEvents();
    return MaterialApp(
      title: 'Motorsports Calendar',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Motorsports Calendar'),
        ),
        body: Center(
          child: (f1Data.isEmpty)
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: f1Data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                        title: Text(f1Data[index].name),
                        subtitle: Text(f1Data[index].place +
                            ' - ' +
                            f1Data[index].raceDate),
                        children: [
                          for (var subevent in f1Data[index].subEvents)
                            ListTile(
                              title: Text(subevent.name),
                              subtitle:
                                  Text(subevent.date + ' - ' + subevent.time),
                            )
                        ]);
                  },
                ),
        ),
      ),
    );
  }

  Future<List<MotorsportEvent>> fetchEvent(url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map eventData = jsonDecode(response.body);
      List<dynamic> events = eventData['events'];
      return events.map((e) => MotorsportEvent.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load event');
    }
  }
}
