class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  final int score;

  Answer(this.answerText, this.score);
}

List<Question> getQuestions() {
  List<Question> list = [];
  var answer = [
    Answer("Never", 0),
    Answer("Rarely", 1),
    Answer("Sometimes", 2),
    Answer("Often", 3),
    Answer("Always",4)
  ];
  //ADD questions and answer here

  list.add(Question(
    "How often do you feel overwhelmed or stressed?",answer
  ));

  list.add(Question(
    "How often do you feel sad or depressed?",
   answer
  ));

  list.add(Question(
    "How often do you feel anxious or worried?",
   answer
  ));
  list.add(Question(
    "How often do you feel irritable or angry?",
    answer
  ));

  list.add(Question(
    "How often do you feel lonely or isolated?",
   answer
  ));

  list.add(Question(
    "How often do you have trouble sleeping?",
   answer
  ));
  list.add(Question(
    "How often do you feel tired or fatigued?",
   answer
  ));

  list.add(Question(
    "How often do you feel a lack of interest or pleasure in activities you used to enjoy?",
   answer
  ));
  list.add(Question(
    "How often do you have trouble concentrating or focusing?",
   answer
  ));


  return list;
}