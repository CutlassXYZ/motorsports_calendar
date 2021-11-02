import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motorsports_calendar/models/motorsport_event.dart';
import 'package:motorsports_calendar/services/event_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MotorsportEvent> selectedSeriesData = [];

  @override
  void initState() {
    super.initState();
    getAllSeriesData();
  }

  @override
  Widget build(BuildContext context) {
    sortSelected();
    return Center(
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
                      child: Image.asset('assets/images/f1.png',
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
                      for (var subevent in selectedSeriesData[index].subEvents)
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
    );
  }

  final allSeriesLogos =
      '{"f1":{"logoName":"f1.png"},"motogp":{"logoName":"motogp.png"}}';

  final allSeriesJson = '{"1":{"jsonUrl":"https://jsonkeeper.com/b/PPNR"}}';

  getEvents(details) async {
    EventService eventService = EventService();
    List<MotorsportEvent> seriesData = [];
    seriesData = await eventService.fetchEvent(details['jsonUrl']);
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
}
