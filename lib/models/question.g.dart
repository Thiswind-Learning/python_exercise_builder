// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    level: json['level'] as int,
    question: json['question'] as String,
    hints: json['hints'] as String,
    solution: json['solution'] as String,
    test: json['test'] as String,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'level': instance.level,
      'question': instance.question,
      'hints': instance.hints,
      'solution': instance.solution,
      'test': instance.test,
    };
