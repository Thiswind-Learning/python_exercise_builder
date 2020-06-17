import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:python_exercise_builder/models/question.dart';
import 'package:python_exercise_builder/pages/question_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Question> _list = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var questions = prefs.getStringList('questions');
    print('loadData questions: $questions');
    if (questions != null) {
      setState(() {
        _list = questions.map((item) => Question.fromJson(json.decode(item))).toList();
      });
    }
    _loading = false;
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var questions = _list.map((item) => json.encode(item.toJson())).toList();
    print('saveData questions: $questions');
    prefs.setStringList('questions', questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await saveData();
            },
          )
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ReorderableListView(
              children: _list
                  .asMap()
                  .entries
                  .map((entry) => ListTile(
                        title: Text(
                          entry.value.question,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('Level ${entry.value.level}'),
                        onTap: () async {
                          var question = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QuestionFormPage(question: entry.value),
                            ),
                          );
                          if (question != null) {
                            setState(() {
                              _list[entry.key] = question;
                            });
                          }
                        },
                      ))
                  .toList(),
              header: Text('Questions'),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  _updateItems(oldIndex, newIndex);
                });
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var question = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuestionFormPage(),
            ),
          );
          if (question != null) {
            setState(() {
              _list.add(question);
            });
          }
        },
      ),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    var tmp = _list[oldIndex];
    _list[oldIndex] = _list[newIndex];
    _list[newIndex] = tmp;
  }
}
