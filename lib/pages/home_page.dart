import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:python_exercise_builder/main.dart';
import 'package:python_exercise_builder/pages/question_page.dart';
import 'package:python_exercise_builder/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Widget> _pages = <Widget>[QuestionPage(), SettingPage()];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    var prefs = await LocalStorage.getInstance();
    if (prefs.getString('rawTemplate') == null) {
      prefs.setString('rawTemplate', config.defaultRawTemplate);
    }
    if (prefs.getString('programTemplate') == null) {
      prefs.setString('programTemplate', config.defaultProgramTemplate);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        sizing: StackFit.expand,
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_answer,
            ),
            title: Text(translate('question')),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            title: Text(translate('setting')),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
