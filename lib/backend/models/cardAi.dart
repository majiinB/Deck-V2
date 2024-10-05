class Cardai{
  final String question;
  final String answer;

  Cardai({required this.question, required this.answer});

  factory Cardai.fromJson(Map<String, dynamic> json) => Cardai(
    question: json['question'],
    answer: json['answer'],
  );
}