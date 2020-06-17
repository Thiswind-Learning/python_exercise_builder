import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:python_exercise_builder/config.dart';
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
      _list = questions.map((item) => Question.fromJson(json.decode(item))).toList();
    }
    setState(() {
      _loading = false;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(defaultMargin),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : ReorderableListView(
                children: _list
                    .asMap()
                    .entries
                    .map((entry) => Slidable(
                          key: ValueKey(entry.key),
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            title: Text(
                              entry.value.question,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'Level ${entry.value.level ?? '-'}',
                              maxLines: 1,
                            ),
                            onTap: () async => _handleEdit(entry.key, entry.value),
                          ),
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Share',
                              color: Colors.indigo,
                              icon: Icons.share,
                              onTap: () async => _handleShare(entry.key, entry.value),
                            ),
                          ],
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Star',
                              color: Colors.black45,
                              icon: Icons.star,
                              onTap: () async => _handleStar(entry.key, entry.value),
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async => _handleDelete(entry.key, entry.value),
                            ),
                          ],
                        ))
                    .toList(),
                header: Text('Questions', style: titleStyle),
                onReorder: (oldIndex, newIndex) {
                  _updateItems(oldIndex, newIndex);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async => _handleAdd(),
      ),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (oldIndex != newIndex) {
      setState(() {
        var tmp = _list[oldIndex];
        _list[oldIndex] = _list[newIndex];
        _list[newIndex] = tmp;
      });
    }
  }

  _handleAdd() async {
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
  }

  _handleEdit(int key, Question value) async {
    var question = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionFormPage(question: value),
      ),
    );
    if (question != null) {
      setState(() {
        _list[key] = question;
      });
    }
  }

  _handleDelete(int key, Question value) async {
    setState(() {
      _list.removeAt(key);
    });
  }

  _handleStar(int key, Question value) async {}

  _handleShare(int key, Question value) async {}
}
