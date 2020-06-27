import 'package:flutter/material.dart';
import 'package:pin_input/pin_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _pins;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 300),
            child: Column(children: [
              PinInput((pins) {
                setState(() {
                  _pins = pins;
                });
              }),
              Padding(
                padding: EdgeInsets.only(top: 100),
              ),
              Text(_pins?.join(',') ?? 'none')
            ])),
      ),
    );
  }
}
