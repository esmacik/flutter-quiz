// Erik Macik
// Cross Platform Application Development Fall 2021
// Assignment 1: Dart

/// General `Question` with a stem, correct answer(s), and a response.
abstract class Question {
  /// The main text of the `Question`.
  String stem;

  /// The name of the questions's image resource.
  String? resourceImage;

  /// The correct answer(s) to the `Question`.
  var correct;

  /// The response to the `Question`;
  var response;

  /// Create a `Question` with a stem and correct answer(s).
  Question(this.stem, this.correct, [this.resourceImage]);

  /// Signifies if the `Question` has an answer.
  get isAnswerCorrect;

  /// Signifies if the `Question` has a response.
  get hasResponse;
}
