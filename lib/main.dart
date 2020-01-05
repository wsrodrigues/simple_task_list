import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_task_list/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(TaskApp());

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  var items = new List<Item>();
  var appBarTextController = TextEditingController();

  TaskPage() {
    items = [];
  }

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  _TaskPageState() {
    load();
  }

  void add() {
    setState(() {
      widget.items.add(new Item(title: widget.appBarTextController.text, done: false));
      widget.appBarTextController.text = '';
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('collection');

    if (json != null){
      Iterable iterable = jsonDecode(json);
      List<Item> list = iterable.map((itItem) => Item.fromJson(itItem)).toList();
      setState(() {
        widget.items = list;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('collection', jsonEncode(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: widget.appBarTextController,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black54, fontSize: 24),
          decoration: InputDecoration(
              labelText: 'Click for New Task',
              labelStyle: TextStyle(color: Colors.white)),
        ),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext ctx, int index) {
              final item = widget.items[index];

              return Dismissible(
                  key: Key(index.toString()),
                  child: CheckboxListTile(
                    title: Text(item.title != null ? item.title : ''),
                    value: item.done,
                    onChanged: (value) {
                      setState(() {
                        item.done = value;
                        save();
                      });
                    },
                  ),
                onDismissed: (direction) {
                  remove(index);
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
