import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml_config/yaml_config.dart';

class FlutterConfiguration extends YamlConfig {
  String defaultRawTemplate;
  String defaultProgramTemplate;

  @override
  void init() {
    defaultRawTemplate = get('defaultRawTemplate');
    defaultProgramTemplate = get('defaultProgramTemplate');
    print('config parsed with result: ${this}');
  }

  FlutterConfiguration(String text) : super(text);

  static Future<FlutterConfiguration> fromAsset(String asset) {
    return rootBundle.loadString(asset).then((text) => FlutterConfiguration(text));
  }

  @override
  String toString() {
    return 'FlutterConfiguration{defaultRawTemplate: $defaultRawTemplate, defaultProgramTemplate: $defaultProgramTemplate}';
  }
}
