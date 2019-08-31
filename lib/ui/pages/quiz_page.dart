import 'package:flutter/material.dart';
import 'package:quranquiz/models/category.dart';
import 'package:quranquiz/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quranquiz/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.category.name),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // our code
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      height: 400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text("${_currentIndex + 1}"),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                HtmlUnescape().convert(
                                    widget.questions[_currentIndex].question),
                                textAlign: TextAlign.right,
                                softWrap: true,
                                style: _questionStyle,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...options.map((option) => RadioListTile(
                                    title:
                                        Text(HtmlUnescape().convert("$option")),
                                    groupValue: _answers[_currentIndex],
                                    value: option,
                                    onChanged: (value) {
                                      setState(() {
                                        _answers[_currentIndex] = option;
                                      });
                                    },
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            child: Text(
                                _currentIndex == (widget.questions.length - 1)
                                    ? "Submit"
                                    : "Next"),
                            onPressed: _nextSubmit,
                          ),
                        ),
                        SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80.0)
            ],
          ),
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
