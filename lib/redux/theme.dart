import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final themeDataReducer = combineReducers<AppThemeData>([
  TypedReducer<AppThemeData, RefreshThemeDataAction>(_refresh),
]);

AppThemeData _refresh(AppThemeData themeData, action) {
  themeData = action.themeData;
  return themeData;
}

class RefreshThemeDataAction {
  final AppThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}

class AppThemeData {
  final MaterialColor primarySwatch;
  final Brightness brightness;

  AppThemeData({@required this.primarySwatch, @required this.brightness});

  copyWith({
    MaterialColor primarySwatch,
    Brightness brightness,
  }) {
    return AppThemeData(primarySwatch: primarySwatch ?? this.primarySwatch, brightness: brightness ?? this.brightness);
  }

  @override
  String toString() {
    return 'AppThemeData{primarySwatch: ${primarySwatch}, brightness: ${brightness}}';
  }
}
