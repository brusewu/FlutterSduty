import 'package:flutter/material.dart';
import 'package:task_navigation/task_route.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home: TaskRoute(),
    );
  }
}
