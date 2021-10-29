// Erik Macik
// Cross Platform Application Development Fall 2021
// Assignment 1: Dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/multiple_choice_question.dart';
import '../model/fill_in_the_blank_question.dart';
import 'dart:convert';

/// A client to retrieve quiz questions.
class WebClient {
  /// The authority of the quiz server.
  //final String _quizServer = 'www.cs.utep.edu';
  final String _quizServer = 'cheon.atwebpages.com';

  /// The path to the quiz questions.
  //final String _questionPath = '/cheon/cs4381/homework/quiz/get.php';

  // Backup quiz resource location.
  final String _questionPath = '/quiz/get.php';

  /// The path to the image resource getter.
  //final String _imagePath = '/cheon/cs4381/homework/quiz/figure.php';

  // Backup quiz resource location.
  final String _imagePath = '/quiz/figure.php';

  /// The number of calls this client will need to make to retrieve all questions.
  final int _numQuizzes = 15;

  /// Encoded type of a multiple choice type question.
  final int _questionTypeMultipleChoice = 1;

  /// Encoded type of a fill-in-the-blank type question.
  final int _questionTypeFillIn = 2;

  /// Create new web client.
  WebClient();

  /// Get a quiz from the server given a quiz number.
  Future<http.Response> _fetchQuiz(int quizNum, String username, String pin) async {
    var newQuizNum =
        'quiz' + (quizNum < 10 ? '0' + quizNum.toString() : quizNum.toString());
    var queryParams = {
      'quiz': newQuizNum,
      'user': username,
      'pin': pin
    };
    Uri url = Uri.http(_quizServer, _questionPath, queryParams);
    return await http.get(url);
  }

  /// Get all possible questions from the quiz server.
  Future<List<dynamic>> fetchAllQuestions(String username, String pin) async {
    var responses = <http.Response>[];
    for (var i = 1; i <= _numQuizzes; i++) {
      responses.add(await _fetchQuiz(i, username, pin));
    }

    var questionPool = <dynamic>[];
    for (var response in responses) {
      var parsedJson = json.decode(response.body);
      var parsedQuestions = parsedJson['quiz']['question'];

      for (var parsedQuestion in parsedQuestions) {
        var questionType = parsedQuestion['type'];
        var resource = parsedQuestion['figure'];
        if (questionType == _questionTypeMultipleChoice) {
          var options = <String>[];
          for (var option in parsedQuestion['option']) {
            options.add(option);
          }
          questionPool.add(MultipleChoiceQuestion(
              parsedQuestion['stem'], options, parsedQuestion['answer'] - 1, resource));
        } else if (questionType == _questionTypeFillIn) {
          var answers = <String>{};
          for (var answer in parsedQuestion['answer']) {
            answers.add(answer);
          }
          questionPool
              .add(FillInTheBlankQuestion(parsedQuestion['stem'], answers, resource));
        }
      }
    }

    return questionPool;
  }

  /// Return a quiz of `size` random questions.
  Future<List<dynamic>> fetchAllQuestionsShuffled(String username, String pin, [int size = 200]) async {
    var questionPool = await fetchAllQuestions(username, pin);
    questionPool.shuffle();
    return questionPool.take(size).toList();
  }

  /// Async method that loads an image given its resource name.
  Future<Image> loadImage(String resource) async {
    return Image.network('http://$_quizServer$_imagePath?name=$resource');
  }
}
