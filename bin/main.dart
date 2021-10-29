import 'package:flutter/material.dart';
import 'package:flutter_quiz/view/login_form_widget.dart';

/// Entry point of Flutter Quiz.
void main() {
  runApp(const FlutterQuiz());
}

/// Flutter Quiz material app.
class FlutterQuiz extends StatelessWidget {
  const FlutterQuiz({Key? key}) : super(key: key);

  /// Build Flutter Quiz as a material app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        primaryColor: Colors.indigo,
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark
      ),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Flutter Quiz'),
    );
  }
}

/// Home page state of Flutter Quiz
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  /// The title of the application.
  final String title;

  /// Create using custom state.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State of the app's home page.
class _MyHomePageState extends State<MyHomePage> {

  /// Create a home screen with a scaffold and login screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: const <Widget>[
            LoginForm()
          ],
        ),
      ),
    );
  }
}
