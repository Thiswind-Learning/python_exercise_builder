import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int level;
  final String question;
  final String hints;
  final String solution;
  final String test;

  Question({this.level, this.question, this.hints, this.solution, this.test});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
