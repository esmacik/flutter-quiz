import 'package:flutter/material.dart';
import 'package:flutter_quiz/model/question.dart';
import 'package:flutter_quiz/view/review_view.dart';

/// Full screen scaffold widget that displays the user's grade.
class GradeView extends StatefulWidget {
  final List<dynamic> _questions;
  
  const GradeView(this._questions, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GradeViewState(_questions);
}

/// State for the Grade View widget.
class _GradeViewState extends State<GradeView> {
  final List<dynamic> _questions;

  _GradeViewState(this._questions);

  /// Callback executed when review button is pressed.
  /// Launches the final review screen.
  void _onReviewButtonPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewView(_questions)));
  }

  /// Returns the number of correct responses.
  int _gradeQuiz() {
    return _questions.where((element) => (element as Question).isAnswerCorrect).length;
  }

  /// Create the widget that displays the grade, number of possible points, and
  /// a review button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Grade'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('You earned a score of')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_gradeQuiz()} points',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 28
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('out of ${_questions.length} points.')),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Tap the Review button below to review the questions that were answered incorrectly.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => _onReviewButtonPressed(),
                  child: const Text('Review')
              ),
            )
          ],
        ),
      ),
    );
  }
}