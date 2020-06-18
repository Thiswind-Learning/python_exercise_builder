import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:python_exercise_builder/config.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:python_exercise_builder/main.dart';

class ConfigPage extends StatefulWidget {
  ConfigPage({Key key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _loading = false;
  String rawTemplate, programTemplate;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _loading = true;
    var prefs = await LocalStorage.getInstance();
    rawTemplate = prefs.getString('rawTemplate') ?? config.defaultRawTemplate;
    programTemplate = prefs.getString('programTemplate') ?? config.defaultProgramTemplate;
    setState(() {
      _loading = false;
    });
  }

  saveData() async {
    var prefs = await LocalStorage.getInstance();
    await prefs.setString('rawTemplate', rawTemplate);
    await prefs.setString('programTemplate', programTemplate);
  }

  @override
  Widget build(BuildContext context) {
    var spacer = SizedBox(height: defaultMargin);
    return Scaffold(
      appBar: AppBar(title: Text(translate('setting'))),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(defaultMargin),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'rawTemplate': rawTemplate,
                        'programTemplate': programTemplate,
                      },
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            attribute: "rawTemplate",
                            maxLines: 10,
                            decoration: InputDecoration(
                              labelText: "rawTemplate",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          spacer,
                          FormBuilderTextField(
                            attribute: "programTemplate",
                            maxLines: 10,
                            decoration: InputDecoration(
                              labelText: "programTemplate",
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
            rawTemplate = _fbKey.currentState.value['rawTemplate'];
            programTemplate = _fbKey.currentState.value['programTemplate'];
            saveData();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
