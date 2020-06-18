import 'dart:convert';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:python_exercise_builder/config.dart';
import 'package:python_exercise_builder/models/question.dart';
import 'package:python_exercise_builder/pages/import_export_page.dart';
import 'package:python_exercise_builder/pages/question_form_page.dart';
import 'package:intl/intl.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Question> _list = [];
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    _loading = true;
    var prefs = await LocalStorage.getInstance();
    var questions = prefs.getStringList('questions');
    print('loadData questions: $questions');
    if (questions != null) {
      _list = questions.map((item) => Question.fromJson(json.decode(item))).toList();
    }
    setState(() {
      _loading = false;
    });
  }

  saveData() async {
    var prefs = await LocalStorage.getInstance();
    var questions = _list.map((item) => json.encode(item.toJson())).toList();
    print('saveData questions: $questions');
    prefs.setStringList('questions', questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                            leading: CircleAvatar(child: Text(NumberFormat("000").format(entry.key + 1))),
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
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: <Widget>[
          FloatingActionButton(
            heroTag: 'add',
            child: Icon(Icons.add),
            onPressed: () async => _handleAdd(),
          ),
          FloatingActionButton(
            heroTag: 'import_export',
            child: Icon(Icons.import_export),
            onPressed: () async => _handleImportExport(),
          ),
        ],
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (oldIndex != newIndex && newIndex > -1 && newIndex < _list.length) {
      setState(() {
        var tmp = _list[oldIndex];
        _list[oldIndex] = _list[newIndex];
        _list[newIndex] = tmp;
      });
    }
  }

  _handleImportExport() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImportExportPage(questions: _list),
      ),
    );
    loadData();
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
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('add successfully!'),
        ),
      );
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
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('edit successfully!'),
        ),
      );
    }
  }

  _handleDelete(int key, Question value) async {
    setState(() {
      _list.removeAt(key);
    });
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('delete successfully!'),
      ),
    );
  }

  _handleStar(int key, Question value) async {}

  _handleShare(int key, Question value) async {}
}
