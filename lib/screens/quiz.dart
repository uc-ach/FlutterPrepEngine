import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prepengine_new/flutter_html/flutter_html.dart';
import '../app_provider.dart';
import 'package:provider/provider.dart';
import './question.dart';
import 'package:flutter/cupertino.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isStart = appState.isStart;
    final explanation = appState.isExplanation;
    final questions = appState.getQuestion;
    final nextQues = appState.nextQues;
    return isStart > 0
        ? showQuestion()
        : Center(child: CircularProgressIndicator());
  }
}

class showQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final explanation = appState.isExplanation;
    final questions = appState.getQuestion;
    final nextQues = appState.nextQues;
    final checkAnswer = appState.checkAnswer;
    var bordercolor;
    var color;
    var textColor;
    var icon;
    String ansText;
    if (checkAnswer == 1) {
      ansText = "Correct";
      icon = CupertinoIcons.check_mark;
      bordercolor = Colors.green[200];
      color = Colors.green[100];
      textColor = Colors.green[600];
    } else if (checkAnswer == 2) {
      ansText = "Incorrect";
      icon = CupertinoIcons.clear;
      bordercolor = Colors.red[200];
      color = Colors.red[100];
      textColor = Colors.red[600];
    }
    return nextQues
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              children: [
                Question(
                  questions['question'],
                ),
                explanation
                    ? new Container(
                        width: 200,
                        //margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: bordercolor),
                            color: color),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(icon, color: textColor, size: 35.0),
                              Text(ansText,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor)),
                            ]),
                      )
                    : Container(),
                ...(questions['answers'] as List<dynamic>).map((answer) {
                  return Answer(
                      answer['answer'], answer['seq_str'], explanation);
                }).toList(),
                explanation
                    ? Html(
                        data:
                            "<b>Explanation : </b>" + questions['explanation'],
                        defaultTextStyle: TextStyle(fontSize: 20.0))
                    //style: TextStyle(fontSize: 22.0))
                    : Container(),
              ],
            ));
  }
}
