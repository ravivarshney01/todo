import 'package:flutter/material.dart';
import 'package:todo/modal/todo_item.dart';
import 'package:todo/util/databasehelper.dart';
import 'package:todo/util/dateformat.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<TodoItem> _list = <TodoItem>[];

  void _handleSubmit(String text) async {
    TodoItem item = new TodoItem(text, dateFormatted(), 0);
    int idSaved = await db.saveTodo(item);
    TodoItem addedItem = await db.getTodo(idSaved);
    setState(() {
      _list.insert(0, addedItem);
    });
  }

  @override
  void initState() {
    super.initState();
    _readTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: false,
              itemCount: _list.length,
              itemBuilder: (_, index) {
                return Card(
                    child: ListTile(
                  title: _list[index],
                  onLongPress: () => _updateTodo(index, _list[index]),
                  onTap: () {
                    _list[index].done == 1
                        ? _list[index].sdone(0)
                        : _list[index].sdone(1);
                    _done(_list[index].id, _list[index].done);
                    TodoItem updatedTodo = TodoItem.fromMap({
                      "name": _list[index].name,
                      "dateCreated": _list[index].dateCreated,
                      "id": _list[index].id,
                      "done": _list[index].done
                    });
                    setState(() {
                      _list[index] = updatedTodo;
                    });
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete,size: 36,color: Colors.redAccent,),
                    onPressed: () => _deleteTodo(_list[index].id, index),
                  ),
                ));
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        child: Icon(Icons.add),
        onPressed: _showDialogForm,
      ),
    );
  }

  void _showDialogForm() {
    var alert = new AlertDialog(
      title: Text("Add Todo"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: "Todo",
                hintText: "e.g. Learn Flutter",
                icon: Icon(Icons.note_add),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(_textEditingController.text);
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readTodoList() async {
    List items = await db.getTodos();
    items.forEach((item) {
      setState(() {
        _list.insert(0, TodoItem.fromMap(item));
      });
    });
  }

  _deleteTodo(int id, int index) async {
    await db.deleteTodo(id);
    setState(() {
      _list.removeAt(index);
    });
  }

  _updateTodo(int index, TodoItem item) async {
    _textEditingController.text = item.name;
    var alert = new AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: "Todo",
                hintText: "e.g. Learn Flutter",
                icon: Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            TodoItem updatedTodo = TodoItem.fromMap({
              "name": _textEditingController.text,
              "dateCreated": dateFormatted(),
              "id": item.id,
              "done": item.done
            });
            _handleSubmitUpdate(index, item);

            await db.updateTodo(updatedTodo);
            setState(() {
              _list.insert(index, updatedTodo);
            });
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () {
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitUpdate(int index, TodoItem item) {
    _list.removeAt(index);
    _textEditingController.clear();
  }

  void _done(int id, int done) async {
    await db.doneTodo(id, done);
  }
}
