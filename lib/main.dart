import 'package:flutter/material.dart';
import 'package:motorsports_calendar/pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motorsports Calendar',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Motorsports Calendar'),
          ),
          body: const HomePage()),
    );
  }
}
