import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz/net/web_client.dart';
import 'quiz_view.dart';

/// Full screen scaffold widget that allows the user to select the number of
/// questions they want their quiz to have.
class CreateQuizView extends StatefulWidget {
  final String _username;
  final String _pin;

  const CreateQuizView(String username, String pin, {Key? key}) :
    _username = username,
    _pin = pin,
    super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateQuizViewState(_username, _pin);
}

/// State for screen allowing user to select the number of questions they want.
class _CreateQuizViewState extends State<CreateQuizView> {
  static const NUM_QUESTIONS = 136;
  final String _username;
  final String _pin;
  final WebClient _webClient = WebClient();
  bool _isLoading = false;

  _CreateQuizViewState(this._username, this._pin);

  final TextEditingController _controller = TextEditingController();

  int _enteredValue = 0;

  /// Callback to be executed when the user presses the submit button.
  /// Shows a loading bar and retrieves questions from server.
  void _onSubmitPressed() {
    setState(() {
      _isLoading = true;
    });

    if (_validateTextInput()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Retrieving questions...'),
          backgroundColor: Theme.of(context).primaryColor
        )
      );

      _webClient.fetchAllQuestionsShuffled(_username, _pin).then((questions) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz created!'),
            backgroundColor: Colors.green
          )
        );

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
              QuizView((questions..shuffle()).take(_enteredValue).toList())
          )
        );
      });
    }
  }

  /// Validate that the input text requests a valid number of questions.
  bool _validateTextInput() {
    try {
      var textInt = int.parse(_controller.text);
      if (textInt < 1 || textInt > NUM_QUESTIONS) {
        return false;
      }
      _enteredValue = textInt;
      return true;
    } catch(e) {
      return false;
    }
  }

  /// Create the screen with a scaffold and text input field.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Create a quiz'),
        actions: [
          IconButton(
            onPressed: () => _onSubmitPressed(),
            icon: const Icon(Icons.check_circle))
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            if (_isLoading) LinearProgressIndicator(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('How many questions would you like?')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) => setState(() => {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.format_list_numbered),
                  labelText: 'Number of questions',
                  border: const OutlineInputBorder(),
                  errorText: _validateTextInput() ? null : 'Please enter a number from 1 to $NUM_QUESTIONS.'
                ),
                controller: _controller,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
