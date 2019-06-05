import 'package:flutter/material.dart';
import 'package:todo/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: Home(),
    );
  }
}

