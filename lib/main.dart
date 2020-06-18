import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:python_exercise_builder/flutter_configuration.dart';

import 'app.dart';

/// global configuration from yaml
FlutterConfiguration config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  config = await FlutterConfiguration.fromAsset('assets/config.yaml');
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'zh_CN'],
  );
  runApp(LocalizedApp(delegate, App()));
}
