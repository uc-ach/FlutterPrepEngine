import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import '../app_provider.dart';
import 'package:provider/provider.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isStart = appState.isStart;
    final explanation = appState.isExplanation;
    final questions = appState.getQuestion;
    final nextQues = appState.nextQues;
    return isStart > 0 ? showQuestion() : StartQuiz();
  }
}

class showQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final explanation = appState.isExplanation;
    final questions = appState.getQuestion;
    final nextQues = appState.nextQues;
    return nextQues
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
            children: [
              Question(
                questions['question'],
              ),
              explanation
                  ? new Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Text("Incorrect"),
                    )
                  : Container(),
              ...(questions['answers'] as List<dynamic>).map((answer) {
                return Answer(answer['answer'], answer['seq_str']);
              }).toList(),
              explanation
                  ? Html(
                      data: "<b>Explanation : </b>" + questions['explanation'],
                      defaultTextStyle: TextStyle(fontSize: 20.0))
                  //style: TextStyle(fontSize: 22.0))
                  : Container(),
            ],
          ));
  }
}

class StartQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final nextQues = appState.nextQues;
    return nextQues
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(top: 16.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.play_circle_outline),
                      iconSize: 150.0,
                      onPressed: () {
                        appState.getTestSessionId();
                        //staQuiz();
                      },
                      //color: Colors.blue,
                    ),
                  ],
                ),
              ),
              new Text('Start Quiz',
                  style: new TextStyle(
                      fontSize: 35.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF26C6DA))),
            ],
          ));
  }
}
