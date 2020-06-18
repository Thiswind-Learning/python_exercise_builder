import 'package:flutter/material.dart';
import 'package:python_exercise_builder/redux/locale.dart';
import 'package:python_exercise_builder/redux/theme.dart';

class AppState {
  final AppThemeData appThemeData;
  final Locale locale;

  AppState({this.appThemeData, this.locale});

  factory AppState.initState() => AppState(
        appThemeData: AppThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
        ),
        locale: Locale('en', 'US'),
      );
}

AppState reducer(AppState state, action) {
  return AppState(
    appThemeData: themeDataReducer(state.appThemeData, action),
    locale: localeReducer(state.locale, action),
  );
}
