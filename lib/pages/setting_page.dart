import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:python_exercise_builder/config.dart';
import 'package:python_exercise_builder/pages/config_page.dart';
import 'package:python_exercise_builder/redux.dart';
import 'package:python_exercise_builder/redux/locale.dart';
import 'package:python_exercise_builder/redux/theme.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('setting')),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.red, Color(0xEEF44336)],
                    [Colors.red[800], Color(0x77E57373)],
                    [Colors.orange, Color(0x66FF9800)],
                    [Colors.yellow, Color(0x55FFEB3B)]
                  ],
                  durations: [35000, 19440, 10800, 6000],
                  heightPercentages: [0.20, 0.23, 0.25, 0.30],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                backgroundColor: Colors.transparent,
                size: Size(
                  MediaQuery.of(context).size.width,
                  300,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    translate('setting'),
                    style: headerStyle,
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.alarm),
                          title: Text(translate('notification')),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text(translate('setting')),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ConfigPage(),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Icons.feedback),
                          title: Text(translate('feedback')),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Icons.language),
                          title: Text(translate('language')),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () async {
                            // set up the list options
                            var locales = [
                              const Locale('en', ''),
                              const Locale('zh', ''),
                            ];
                            var selections = locales.map((locale) => SimpleDialogOption(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Container(
                                        child: Text(locale.languageCode == 'zh' ? translate('zh') : translate('en')))),
                                onPressed: () {
                                  Navigator.of(context).pop(locale);
                                }));
                            // set up the SimpleDialog
                            SimpleDialog dialog = SimpleDialog(
                              title: Text(translate('language')),
                              children: <Widget>[
                                ...selections,
                              ],
                            );
                            // show the dialog
                            Locale locale = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                            if (locale != null) {
                              StoreProvider.of<AppState>(context).dispatch(RefreshLocaleAction(locale));
                            }
                          },
                        ),
                        _buildDivider(),
                        StoreConnector<AppState, AppThemeData>(
                          converter: (store) {
                            return store.state.appThemeData;
                          },
                          builder: (context, themeData) => ListTile(
                            leading: Icon(Icons.palette),
                            title: Text(translate('theme_color')),
                            trailing: Icon(Icons.navigate_next),
                            onTap: () async {
                              // set up the list options
                              var colors = <MaterialColor>[
                                Colors.blue,
                                Colors.red,
                                Colors.purple,
                                Colors.green,
                                Colors.brown,
                                Colors.teal,
                                Colors.amber,
                                Colors.orange,
                                Colors.indigo,
                              ];
                              var selections = colors.map((color) => SimpleDialogOption(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(color: color, height: 50, width: 200),
                                  onPressed: () {
                                    Navigator.of(context).pop(color);
                                  }));
                              // set up the SimpleDialog
                              SimpleDialog dialog = SimpleDialog(
                                title: Text(translate('theme_color')),
                                children: <Widget>[
                                  ...selections,
                                ],
                              );
                              // show the dialog
                              MaterialColor color = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialog;
                                },
                              );
                              if (color != null) {
                                StoreProvider.of<AppState>(context).dispatch(
                                  RefreshThemeDataAction(
                                    AppThemeData(
                                      primarySwatch: color,
                                      brightness: themeData.brightness,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        _buildDivider(),
                        StoreConnector<AppState, AppThemeData>(
                          converter: (store) {
                            return store.state.appThemeData;
                          },
                          builder: (context, themeData) => SwitchListTile(
                            activeColor: Colors.purple,
                            value: themeData.brightness == Brightness.dark,
                            title: Text(translate('night_mode')),
                            onChanged: (value) {
                              StoreProvider.of<AppState>(context).dispatch(
                                RefreshThemeDataAction(
                                  themeData.copyWith(brightness: value ? Brightness.dark : Brightness.light),
                                ),
                              );
                            },
                          ),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text(translate('about')),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: defaultMargin,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
