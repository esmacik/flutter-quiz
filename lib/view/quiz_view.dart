import 'package:flutter/material.dart';
import 'package:flutter_quiz/model/fill_in_the_blank_question.dart';
import 'package:flutter_quiz/model/multiple_choice_question.dart';
import 'package:flutter_quiz/model/question.dart';
import 'package:flutter_quiz/net/web_client.dart';
import 'package:flutter_quiz/view/grade_view.dart';
import 'package:flutter_html/flutter_html.dart';

/// Full screen scaffold widget that allows the user to take a quiz.
/// As the user enters answers, they are automatically recorded.
class QuizView extends StatefulWidget {
  const QuizView(List<dynamic> questions, {Key? key}) :
    _questions = questions,
    super(key: key);

  final List<dynamic> _questions;

  @override
  State<StatefulWidget> createState() => _QuizViewState(_questions);
}

/// State for the full screen quiz view.
class _QuizViewState extends State<QuizView> {

  /// The list of questions this widget will display.
  final List<dynamic> _questions;
  final TextEditingController _controller = TextEditingController();
  final WebClient _webClient = WebClient();

  _QuizViewState(this._questions);
  int _questionIndex = 0;

  /// Get the number of questions that have been given an answer, for the progress bar.
  int _getNumQuestionsAnswered() {
    return _questions.where((element) => (element as Question).hasResponse as bool).length;
  }

  /// Move to the next question and redraw the widget.
  void _nextQuestion(){
    setState(() => _questionIndex = (_questionIndex + 1) % _questions.length);
  }

  /// Move to the previous question and redraw the widget.
  void _previousQuestion() {
    setState(() => _questionIndex = (_questionIndex == 0) ? _questions.length - 1 : _questionIndex-1);
  }

  /// Callback to be executed when the submit button is pressed.
  /// Proceeds the the final grade screen.
  void _onSubmitButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GradeView(_questions))
    );
  }

  /// Convenience getter to get the question at the current index.
  get _currQuestion => _questions[_questionIndex];

  /// Create the scaffold widget to display the questions.
  /// Supports FillInTheBlank and MultipleChoiceQuestions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_questionIndex+1}/${_questions.length}'),
        actions: [
          if (_questions.length > 1) ...[
            IconButton(
              onPressed: () => _previousQuestion(),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              onPressed: () => _nextQuestion(),
              icon: const Icon(Icons.chevron_right)
            )
          ],
          IconButton(
            onPressed: () => _onSubmitButtonPressed(),
            icon: const Icon(Icons.cloud_upload)
          )
        ]
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Number of questions answered: ${_getNumQuestionsAnswered()}/${_questions.length}'),
              ),
            ),
            LinearProgressIndicator(
              value: _getNumQuestionsAnswered() / _questions.length,
              color: _getNumQuestionsAnswered() == _questions.length ? Colors.green : null,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: /*Text(_currQuestion.stem),*/ Html(data: _currQuestion.stem)
            ),
            if ((_currQuestion as Question).resourceImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: _webClient.loadImage((_currQuestion as Question).resourceImage!),
                    builder: (context, AsyncSnapshot<Image> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;  // image is ready
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            if (_currQuestion is MultipleChoiceQuestion) ...(_currQuestion as MultipleChoiceQuestion).options.map((option) =>
              Row(
                children: [
                  Radio<int>(
                    value: (_currQuestion as MultipleChoiceQuestion).options.indexOf(option),
                    groupValue: (_currQuestion as MultipleChoiceQuestion).response,
                    onChanged: (option) => setState(() {
                      (_currQuestion as MultipleChoiceQuestion).response = option;
                    })
                  ),
                  Flexible(child: Html(data: option))
                ],
              )
            ).toList(),
            if (_currQuestion is FillInTheBlankQuestion) Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller..text = (_currQuestion as FillInTheBlankQuestion).response ?? '',
                onChanged: (value) => (_currQuestion as FillInTheBlankQuestion).response = value,
                decoration: const InputDecoration(
                  labelText: 'Your answer here...',
                  prefixIcon: Icon(Icons.question_answer),
                  border: OutlineInputBorder()
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}