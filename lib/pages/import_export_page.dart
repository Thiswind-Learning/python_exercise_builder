import 'dart:convert';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:mustache_template/mustache.dart';
import 'package:python_exercise_builder/config.dart';
import 'package:python_exercise_builder/models/question.dart';

class ImportExportPage extends StatefulWidget {
  ImportExportPage({Key key, @required this.questions}) : super(key: key);
  final List<Question> questions;

  @override
  _ImportExportPageState createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController __textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    __textEditingController.dispose();
    super.dispose();
  }

  void loadData() async {
    setState(() {
      _loading = true;
    });
    __textEditingController.text = JsonEncoder.withIndent("  ").convert(widget.questions);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Import & Export')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(defaultMargin),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton.icon(
                            onPressed: () async {
                              List<dynamic> data = json.decode(__textEditingController.text);
                              var questions = data.map((item) => Question.fromJson(item)).toList();
                              var prefs = await LocalStorage.getInstance();
                              var rawTemplate = prefs.getString('rawTemplate');
                              var template = Template(rawTemplate);
                              var rawResult = questions
                                  .map(
                                    (item) => template.renderString({
                                      'level': item.level,
                                      'question': item.question,
                                      'hints': item.hints,
                                      'solution': item.solution,
                                      'test': item.solution,
                                    }),
                                  )
                                  .toList()
                                  .join('\n\n\n');
                              Clipboard.setData(ClipboardData(text: rawResult));
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('copy rawTemplate successfully!'),
                                ),
                              );
                            },
                            icon: Icon(Icons.content_copy),
                            label: Text('copy as raw')),
                        RaisedButton.icon(
                            onPressed: () async {
                              List<dynamic> data = json.decode(__textEditingController.text);
                              var questions = data.map((item) => Question.fromJson(item)).toList();
                              var prefs = await LocalStorage.getInstance();
                              var programTemplate = prefs.getString('programTemplate');
                              var template = Template(programTemplate);
                              var programResult = questions
                                  .map(
                                    (item) => template.renderString({
                                      'level': item.level,
                                      'question': item.question,
                                      'hints': item.hints,
                                      'solution': item.solution,
                                      'test': item.solution,
                                    }),
                                  )
                                  .toList()
                                  .join('\n\n\n');
                              Clipboard.setData(ClipboardData(text: programResult));
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('copy programTemplate successfully!'),
                                ),
                              );
                            },
                            icon: Icon(Icons.content_copy),
                            label: Text('copy as program')),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton.icon(
                            onPressed: () async {
                              List<dynamic> data = json.decode(__textEditingController.text);
                              // var questions = data.map((item) => json.encode(item)).toList();
                              // var prefs = await LocalStorage.getInstance();
                              // prefs.setStringList('questions', questions);
                              var questions = data.map((item) => Question.fromJson(item)).toList();
                              Navigator.of(context).pop(questions);
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('import successfully!'),
                                ),
                              );
                            },
                            icon: Icon(Icons.input),
                            label: Text('import')),
                        RaisedButton.icon(
                            onPressed: () async {
                              Clipboard.setData(ClipboardData(text: __textEditingController.text));
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('export successfully, copied to the clipboard!'),
                                ),
                              );
                            },
                            icon: Icon(Icons.content_copy),
                            label: Text('export')),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultMargin),
                      child: TextField(
                        maxLines: 10,
                        controller: __textEditingController,
                        decoration: InputDecoration(labelText: 'Content'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
