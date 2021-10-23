import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final jsonData =
      '''{"events":[{"name":"Australian Grand Prix","place":"Melbourne, Australia","raceDate":"21 Mar 2022","subEvents":[{"name":"Free Practice 1","time":"12 PM","date":"19 Mar 2022"},{"name":"Free Practice 2","time":"3 PM","date":"19 Mar 2022"},{"name":"Free Practice 3","time":"12 PM","date":"20 Mar 2022"},{"name":"Qualifying","time":"3 PM","date":"20 Mar 2022"},{"name":"Race","time":"3 PM","date":"21 Mar 2022"}]},{"name":"Singapore Grand Prix","place":"Singapore","raceDate":"21 Apr 2022","subEvents":[{"name":"Free Practice 1","time":"12 PM","date":"19 Apr 2022"},{"name":"Free Practice 2","time":"3 PM","date":"19 Apr 2022"},{"name":"Free Practice 3","time":"12 PM","date":"20 Apr 2022"},{"name":"Qualifying","time":"3 PM","date":"20 Apr 2022"},{"name":"Race","time":"3 PM","date":"21 Apr 2022"}]}]}''';

  @override
  Widget build(BuildContext context) {
    var parsedJson = jsonDecode(jsonData);

    return MaterialApp(
      title: 'Motorsports Calendar',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Motorsports Calendar'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: parsedJson['events'].length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                  title: Text(parsedJson['events'][index]['name']),
                  subtitle: Text(parsedJson['events'][index]['place'] +
                      ' - ' +
                      parsedJson['events'][index]['raceDate']),
                  // children: <Widget>[
                  //   ListTile(title: Text('This is tile number 1')),
                  // ],
                  children: [
                    for (var subevent in parsedJson['events'][index]
                        ['subEvents'])
                      ListTile(
                        title: Text(subevent['name']),
                        subtitle:
                            Text(subevent['date'] + ' - ' + subevent['time']),
                      )
                  ]);
            },
          ),
        ),
      ),
    );
  }
}
