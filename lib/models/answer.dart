class Answer {
  final String answer;
  final int impact;

  Answer({required this.answer, required this.impact});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'],
      impact: json['impact'],
    );
  }
}