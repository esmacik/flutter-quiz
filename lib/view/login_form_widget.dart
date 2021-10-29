import 'package:flutter/material.dart';
import 'package:flutter_quiz/net/login_validator.dart';
import 'package:flutter_quiz/view/create_quiz_view.dart';

/// Custom widget for logging in a user.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  /// Create using custom state.
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  /// Global key of username field.
  final GlobalKey<FormFieldState<String>> _usernameFormFieldKey = GlobalKey();

  /// Global key of password field.
  final GlobalKey<FormFieldState<String>> _passwordFormFieldKey = GlobalKey();

  /// Login validator that uses standard network calls.
  final _validator = LoginValidator();

  bool _isLoading = false;

  /// Method that tries to login a user. If the login is successful, download all
  /// quiz questions and go to next screen allowing user to create quiz
  void _tryLogin() {
    _validator.loginUser(_values['username'], _values['password']).then((success) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Login successful. Welcome ${_values['username']}!' : 'Login unsuccessful. Please try again.'),
          backgroundColor: success ? Colors.green : Colors.red,
        )
      );

      if (success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateQuizView(
                _values['username'],
                _values['password']
              )
            )
          );
        } else {
          _isLoading = false;
        }
      }
    );
  }

  bool _notEmpty(String value) => value.isNotEmpty;

  get _values => {
    'username': _usernameFormFieldKey.currentState?.value,
    'password': _passwordFormFieldKey.currentState?.value
  };

  /// Create a login widget with username field, login field, login button, and
  /// reset button.
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          children: <Widget>[
            if (_isLoading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _usernameFormFieldKey,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder()
                ),
                validator: (value) => _notEmpty(value ?? '') ? null : 'Username is required.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _passwordFormFieldKey,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder()
                ),
                validator: (value) => _notEmpty(value ?? '') ? null : 'Password is required',
              ),
            ),
            Builder(builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () {
                      if (Form.of(context)!.validate()) {
                        _tryLogin();
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Reset'),
                    onPressed: () => Form.of(context)?.reset(),
                  )
                ],
              );
            })
          ],
        )
    );
  }
}