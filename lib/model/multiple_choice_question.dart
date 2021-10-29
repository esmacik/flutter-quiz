// Erik Macik
// Cross Platform Application Development Fall 2021
// Assignment 2: Flutter

import '../model/question.dart';

/// Class that represents a multiple choice type question.
class MultipleChoiceQuestion extends Question {
  /// Possible selections for this question.
  List<String> options;

  /// Create a multiple choice question with a stem, a set of options, and an
  /// optional image resource name.
  MultipleChoiceQuestion(String stem, this.options, int correct, [String? resource])
      : super(stem, correct, resource);

  /// Create a true/false question.
  MultipleChoiceQuestion.trueFalse(String stem, int correct)
      : options = ['True', 'False'],
        super(stem, correct);

  /// `true` if the response matches the correct answer and `false` otherwise.
  @override
  bool get isAnswerCorrect => response == correct;

  /// The correct selection number.
  @override
  int get correct => super.correct as int;

  /// The provided response number.
  @override
  int? get response => super.response as int?;

  /// `true` if this question has a response and `false` otherwise.
  @override
  get hasResponse => super.response != null;

  /// Set the response to this question. If the response number is invalid,
  /// no change will be made to the object.
  @override
  set response(response) {
    if (response >= 0 && response <= options.length) {
      super.response = response;
    }
  }
}
