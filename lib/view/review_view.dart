import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz/model/fill_in_the_blank_question.dart';
import 'package:flutter_quiz/model/multiple_choice_question.dart';
import 'package:flutter_quiz/model/question.dart';

/// Full screen scaffold widget that displays the final review for the user.
class ReviewView extends StatefulWidget {
  const ReviewView(this._questions, {Key? key}) : super(key: key);

  final List<dynamic> _questions;

  @override
  State<StatefulWidget> createState() => _ReviewViewState(_questions);
}

/// State class for the final review screen.
class _ReviewViewState extends State<ReviewView> {
  final List<dynamic> _questions;

  _ReviewViewState(this._questions);

  /// Callback to be executed when a questions is tapped.
  /// Display an alert dialog describing all possible responses and the user's response.
  void _onQuestionTapped(question) {
    showDialog(context: context, builder: (context) =>
      AlertDialog(
        title: Html(data: question.stem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  question.isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                  color: question.isAnswerCorrect ? Colors.green : Colors.red,
                ),
              ),
            ),
            if (question is FillInTheBlankQuestion) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  question.correct.join(', '),
                  style: const TextStyle(
                    color: Colors.green
                  ),
                ),
              )
            ]
            else ...question.options.map((option) =>
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: (question.options.indexOf(option) == question.correct) ? Colors.green : Colors.red
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                  child: Text('Your answer: '),
                ),
                Flexible(
                  child: Text(
                    (question is FillInTheBlankQuestion)
                        ? question.response ?? 'None'
                        : question.response == null
                          ? 'None'
                          : (question as MultipleChoiceQuestion).options[question.response!],
                    style: TextStyle(
                      color: question.isAnswerCorrect ? Colors.green : Colors.red
                    )
                  ),
                )
              ],
            ),
          ]
        ),
      )
    );
  }

  /// Build the full screen widget displaying the list of questions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Tap a question for more details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            ..._questions.map((question) =>
              GestureDetector(
                onTap: () => _onQuestionTapped(question),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        (question as Question).isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                        color: question.isAnswerCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: question.stem
                        ),
                      ),
                    )
                  ],
                ),
              )
            ).toList()
          ],
        ),
      ),
    );
  }
}
