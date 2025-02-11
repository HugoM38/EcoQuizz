import 'package:ecoquizz/models/answer.dart';

class Question {
  final int id;
  final int ordre;
  final String question;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.ordre,
    required this.question,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = json['answers'] as List;
    List<Answer> answerList =
        list.map((reponseJson) => Answer.fromJson(reponseJson)).toList();

    return Question(
      id: json['id'],
      ordre: json['ordre'],
      question: json['question'],
      answers: answerList,
    );
  }
}