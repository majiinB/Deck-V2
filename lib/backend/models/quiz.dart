class Quiz {
  final String id;
  final String associatedDeckId;
  final DateTime createdAt;
  final String quizType;
  final bool isDeleted;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.associatedDeckId,
    required this.createdAt,
    required this.quizType,
    required this.isDeleted,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      associatedDeckId: json['associated_deck_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']['_seconds'] * 1000),
      quizType: json['quiz_type'],
      isDeleted: json['is_deleted'],
      questions: (json['questions'] as List<dynamic>).map((q) => QuizQuestion.fromJson(q)).toList(),
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final DateTime createdAt;
  final String relatedFlashcardId;
  final List<QuizChoice> choices;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.createdAt,
    required this.relatedFlashcardId,
    required this.choices,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']['_seconds'] * 1000),
      relatedFlashcardId: json['related_flashcard_id'],
      choices: (json['choices'] as List<dynamic>).map((c) => QuizChoice.fromJson(c)).toList(),
    );
  }
}

class QuizChoice {
  final String id;
  final String text;
  final bool isCorrect;

  QuizChoice({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory QuizChoice.fromJson(Map<String, dynamic> json) {
    return QuizChoice(
      id: json['id'],
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }
}
