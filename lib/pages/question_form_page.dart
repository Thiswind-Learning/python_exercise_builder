import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:python_exercise_builder/config.dart';
import 'package:python_exercise_builder/models/question.dart';
import 'package:intl/intl.dart';

class QuestionFormPage extends StatefulWidget {
  QuestionFormPage({Key key, this.question}) : super(key: key);
  final Question question;

  @override
  _QuestionFormPageState createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    var question = widget.question;
    var spacer = SizedBox(height: defaultMargin);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(defaultMargin),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'level': question?.level,
                  'question': question?.question,
                  'hints': question?.hints,
                  'solution': question?.solution,
                  'test': question?.test,
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderSlider(
                      attribute: 'level',
                      min: 0,
                      max: 5,
                      initialValue: question?.level?.toDouble() ?? 0,
                      divisions: 5,
                      decoration: InputDecoration(
                        labelText: 'Select an level',
                      ),
                      numberFormat: NumberFormat("#"),
                      valueTransformer: (value) {
                        print('valueTransformer');
                        return (value as double).floor();
                      },
                    ),
                    // FormBuilderChoiceChip(
                    //   attribute: 'level',
                    //   decoration: InputDecoration(
                    //     labelText: 'Select an level',
                    //   ),
                    //   options: [
                    //     FormBuilderFieldOption(value: null, child: Text('Level -')),
                    //     FormBuilderFieldOption(value: 1, child: Text('Level 1')),
                    //     FormBuilderFieldOption(value: 2, child: Text('Level 2')),
                    //     FormBuilderFieldOption(value: 3, child: Text('Level 3')),
                    //     FormBuilderFieldOption(value: 4, child: Text('Level 4')),
                    //     FormBuilderFieldOption(value: 5, child: Text('Level 5')),
                    //   ],
                    // ),
                    spacer,
                    FormBuilderTextField(
                      attribute: "question",
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "question",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    spacer,
                    FormBuilderTextField(
                      attribute: "hints",
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "hints",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    spacer,
                    FormBuilderTextField(
                      attribute: "solution",
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "solution",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    spacer,
                    FormBuilderTextField(
                      attribute: "test",
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "test",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          if (_fbKey.currentState.saveAndValidate()) {
            var question = Question.fromJson(_fbKey.currentState.value);
            Navigator.of(context).pop(question);
          }
        },
      ),
    );
  }
}
