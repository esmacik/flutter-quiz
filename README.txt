CS 4381/5381: TSE -- Cross-Platform Application Development, Fall 2021

			   HOMEWORK 2: Flutter
                 (File $Date: 2021/10/17 03:27:26 $)

Due: October <s>22</s> 25

This assignment may be done individually or in pairs. If you work in
pair, however, you will need to fill out the contribution form.

The purpose of this assignment is to become familiar with the Flutter
framework. You will learn how to use various widgets provided by the
Flutter SDK [3] and other Flutter developers (see
https://pub.dev/flutter/packages).

Create a Flutter version of the app that you developed in HW1. Focus
on the design of the UI by using as much code as possible from HW1.
You should  be able to reuse most of the model code. Your  app shall
meet all the  relevant requirements from HW1 (see the HW1 handout) as
well as a few new ones listed below.

R1. Your app shall support a question with a picture. A question may
    have a picture associated with it as shown below, and the picture
    provides an illustration to the question.
    
    { "type": 1,
      "stem": "Which widget(s) is/are used to create a UI shown below? ",
      "figure": "quiz02-fig1.png",
      "answer": 2,
      "option": [
        "Switch",
        "Switch and Text",
        "Container and Switch",
        "Container, Switch, and Text"
      ]
    }
    
    The optional "figure" attribute specifies the file name of the
    associated picture. You can obtain the picture by visiting a URL:
    http://www.cs.utep.edu/cheon/cs4381/homework/quiz/
    figure.php?name=<file-name>. A sample question containing a figure
    can be found in quiz02 (see R4 below).
    
    Hint: Use the Image widget to display a picture (see pages 161-162
    of the textbook).

    Hint: Consider using the FutureBuilder widget for aync
    programming, i.e., to generate a widget with async data, an image
    fetched over HTTP (see https://api.flutter.dev/flutter/widgets/
    FutureBuilder-class.html).
     
R2. Your app shall consist of multiple screens to:
    - obtain a login credential (username and password),
    - create a quiz,
    - show questions and prompt for answers (see R5 below),
    - grade answers,
    - review incorrectly answered questions (see R6 below).

R3. Your app shall use the following Web service to authenticate a user.

    URL: http://www.cs.utep.edu/cheon/cs4381/homework/quiz/login.php
    Protocol: GET
    Required parameters
      Name	Type	Description
      user      String  User name
      pin       String  Password
    Response
      Name	Type	Description
      response	Boolean True if the provided login credential is valid
    Examples
      http://www.cs.utep.edu/cheon/cs4381/homework/quiz/login.php?user=guest&pin=1234
      Output: {"response": false, 
               "reason": "Incorrect user ID or pin"}

      http://www.cs.utep.edu/cheon/cs4381/homework/quiz/login.php?user=johndoe&pin=1776
      Output: {"response": true}

    To test your app, use your UTEP username as the login name (e.g.,
    johndoe for johndoe@miners.utep.edu) and the last four digits of
    your UTEP ID number (e.g., 1776 for 80531776)

R4. Your app shall acquire questions from the Web service specified
    below to populate your pool of questions.

    URL: http://www.cs.utep.edu/cheon/cs4381/homework/quiz/get.php
    Protocol: GET
    Required parameters
      Name	Type	Description
      user      String  User name
      pin       String  Password
      quiz      String	Requested quiz, e.g., quiz01
    Response
      Name	Type	Description
      response	Boolean True if request is accepted; false otherwise
      reason    String  Error message if response is false
      quiz	String  JSON-encoded quiz consisting of questions 
    Examples
      http://www.cs.utep.edu/cheon/cs4381/homework/quiz/get.php?user=guest&pin=1234&quiz=quiz00
      Output: {"response": false, 
               "reason": "Incorrect user name or password"}

      http://www.cs.utep.edu/cheon/cs4381/homework/quiz/get.php?user=johndoe&pin=1776quiz=quiz01
      Output: 
        {"response": true, "quiz": { "name": "Quiz 01", "question": [ 
          { "type": 1, "stem": "Flutter ...", "answer": 1, 
            "option": [ "true", "false" ]},
          { "type": 2, "stem": "________ lets you ...",
            "answer": ["Hot reload", "hot reloading"]},
          ... ]}}

R5. Your app shall provide a way to navigate through questions, e.g.,
    move to the previous/next questions. Your app shall also provide a
    visual indicator showing the progress of the test, e.g., the
    numbers of questions before/after the current question.

R6. Your app shall provide a way to review questions that were
    answered incorrectly, e.g., a review session at the end of the
    test.

R7. Your app shall handle a network error or delay smoothly. For
    example, if a network connection to the server is slow, your app
    shall provide visual feedback to the user, say by showing a
    CircularProgressIndicator (pages 157-158 of the textbook).

R8. Document your code using Dartdoc comments. 

1. (10 points) Design your app and express your design by drawing a
   UML class diagram [2]. You should focus on designing those classes
   that are modified (from your HW1 design) or newly introduced;
   highlight them in your diagram.

   - Your class diagram should show the main components (classes) 
     of your app along with their roles and relationships. 
   - Your model (business logic) classes should be cleanly separated 
     from the view/control (UI or widget) classes.
   - For each class in your diagram, define key (public) operations
     to show its roles or responsibilities.
   - For each association including aggregation and composition, include
     at least a label, multiplicities, and directions.
   - For each class appearing in your class diagram, provide a brief 
     description.

2. (90 points) Code your design by making your code conform to your
   design.

3. (10 bonus points) Provide a custom launch icon for Android or
    iOS. You may have a platform-neutral icon or a platform-specific
    one for either Android or iOS depending on your development
    platform (refer to a package named flutter_launcher_icons at
    https://pub.dev/packages/flutter_launcher_icons).

4. (10 bonus points) Provide an option (e.g., Settings) to store and
   remember the login credential so that the user enters the login
   credential just once (see the Lesson entitled "Flutter, Part 2).
   Hint: use the shared_preferences package 
   (https://pub.dev/packages/shared_preferences).

TESTING
	
   Your code should compile on Flutter version 1.12 or later
   versions. Your app should run correctly on Android and iOS.

WHAT AND HOW TO TURN IN
   
   You should submit your program along with supporting documents
   through Blackboard. You should submit a single zip file that
   contains:

   - UML class diagram along with a description (pdf or docx)
   - contribution form if done in pair (pdf or docx)
   - Source code. The Dart src directory in your project folder
     (bin/main.dart and lib/*). Include only Dart source code files;
     do not include other files such as build files or the whole
     project folder.
   - pubspec.yaml: lists package dependencies and other metadata.

   If you work in pairs, include both names in the zip file name and
   make only one submission.

DEMO

   You will need to make one or two minutes demo of your app to the
   course staff.

GRADING

   You will be graded on the quality of your design and how clear your
   code is. Excessively long code will be penalized: don't repeat code
   in multiple places. Your code should be well documented by using
   Dartdoc comments and sensibly indented so it is easy to read.

   Be sure your name is in the comments in your source code.

REFERENCES 

   [1] Holger Gast, How to Use Objects, Addison-Wesley, 2016.
       Sections 9.1 and 9.2. Ebook available from UTEP library.

   [2] Martina Seidl, et al., UML@Classroom: An Introduction to
       Object-Oriented Modeling, Springer, 2015. Ebook.

   [3] Widget catalog,
       https://flutter.dev/docs/development/ui/widgets
