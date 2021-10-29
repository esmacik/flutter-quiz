// Erik Macik
// Cross Platform Application Development Fall 2021
// Assignment 2: Flutter

import '../model/question.dart';

/// Class that represents a fill-in-the-blank type [Question].
class FillInTheBlankQuestion extends Question {

  /// Create a fill in the blank question with a stem, list of correct responses,
  /// and an optional image resource name.
  FillInTheBlankQuestion(String stem, Set<String> correct, [String? resource])
      : super(stem, correct, resource);

  /// `true` if the provided answer is one of the correct answers and
  /// `false` otherwise.
  @override
  bool get isAnswerCorrect => correct.contains(response);

  /// The set of possible correct answers to this question.
  @override
  Set<String> get correct => super.correct as Set<String>;

  /// The response to this question.
  @override
  String? get response => super.response as String?;

  /// `true` if the question has a response and `false` otherwise.
  @override
  bool get hasResponse => super.response != null;
}
