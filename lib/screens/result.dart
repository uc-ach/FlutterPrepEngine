import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  //final int resultScore;

  String get resultPhrase {
    String resultText = "Congratulations!! You Have Mastered all Questions.";
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: Text(
              'Restart Quiz!',
              style: TextStyle(
                fontSize: 20.0,
                //color: Colors.yellow,
              ),
            ),
            textColor: Colors.blue,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
