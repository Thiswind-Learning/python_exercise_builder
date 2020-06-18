import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final localeReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocaleAction>(_refresh),
]);

Locale _refresh(Locale locale, RefreshLocaleAction action) {
  return action.locale;
}

class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}
