import 'package:flutter/material.dart';
import 'package:python_exercise_builder/config.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultMargin),
      child: Container(
        child: Center(child: Text('Settings')),
      ),
    );
  }
}
