import 'package:flutter/material.dart';
import 'package:todo/ui/todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
      ),
      body: TodoScreen(),
    );
  }
}