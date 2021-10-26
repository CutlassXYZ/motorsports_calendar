import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:motorsports_calendar/models/motorsport_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final allSeriesJson =
      '{"f1":{"jsonUrl":"https://jsonkeeper.com/b/8IRY","logoName":"f1.png"},"motogp":{"jsonUrl":"https://jsonkeeper.com/b/8IRY","logoName":"motogp.png"}}';

  List<MotorsportEvent> selectedSeriesData = [];

  getEvents(details) async {
    List<MotorsportEvent> seriesData = [];
    seriesData = await fetchEvent(details['jsonUrl']);
    for (var element in seriesData) {
      element.eventLogo = details['logoName'];
      element.earliestTime = DateTime.parse(
          element.subEvents[0].date + ' ' + element.subEvents[0].time);
      setState(() {
        selectedSeriesData.add(element);
      });
    }
  }

  getAllSeriesData() {
    Map<String, dynamic> allSeries = jsonDecode(allSeriesJson);

    allSeries.forEach((key, value) {
      getEvents(value);
    });
  }

  sortSelected() {
    selectedSeriesData.sort((s1, s2) {
      DateTime s1time = s1.earliestTime ?? DateTime.now();
      DateTime s2time = s2.earliestTime ?? DateTime.now();
      return s1time.compareTo(s2time);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllSeriesData();
  }

  @override
  Widget build(BuildContext context) {
    sortSelected();
    return MaterialApp(
      title: 'Motorsports Calendar',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Motorsports Calendar'),
        ),
        body: Center(
          child: (selectedSeriesData.isEmpty)
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: selectedSeriesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                        leading: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                            maxWidth: 50,
                            maxHeight: 50,
                          ),
                          child: Image.asset(
                              'assets/images/' +
                                  (selectedSeriesData[index].eventLogo ?? ''),
                              fit: BoxFit.cover),
                        ),
                        title: Text(selectedSeriesData[index].name),
                        subtitle: Text(
                          selectedSeriesData[index].place +
                              ' - ' +
                              DateFormat("yMMMd").format(DateTime.parse(
                                  selectedSeriesData[index].raceDate)),
                        ),
                        children: [
                          for (var subevent
                              in selectedSeriesData[index].subEvents)
                            ListTile(
                              title: Text(subevent.name),
                              subtitle: Text(DateFormat("yMMMd")
                                      .format(DateTime.parse(subevent.date)) +
                                  ' - ' +
                                  DateFormat("Hm").format(DateTime.parse(
                                      subevent.date + ' ' + subevent.time))),
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
