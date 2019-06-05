import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  String _name;
  String _dateCreated;
  int _id;
  int _done;
  TodoItem(this._name, this._dateCreated, this._done);

  TodoItem.map(dynamic obj) {
    this._name = obj["name"];
    this._dateCreated = obj["dateCreated"];
    this._done = obj["done"];
    this._id = obj["id"];
  }

  String get name => _name;
  String get dateCreated => _dateCreated;
  int get done => _done;
  int get id => _id;
  int sdone(done) => _done = done;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = _name;
    map['dateCreated'] = _dateCreated;
    map['done'] = _done;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    this._name = map["name"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
    this._done = map['done'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _name,
                style: TextStyle(
                    fontSize: 16.9,
                    fontWeight: FontWeight.bold,
                    decoration: _deco()),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "Created on: $_dateCreated",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  TextDecoration _deco() {
    return _done == 1 ? TextDecoration.lineThrough : TextDecoration.none;
  }
}
