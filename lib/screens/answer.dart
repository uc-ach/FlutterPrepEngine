import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../app_provider.dart';
import 'package:provider/provider.dart';

class Answer extends StatelessWidget {
  final String answerText;
  final String id;
  final explanation;
  Answer(this.answerText, this.id, this.explanation);

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final groupValue = appState.groupValue;
    //String color = "0xff7986CB";
    //double width = MediaQuery.of(context).size.width;
    //double yourWidth = width * 0.90;
    print(answerText);
    return RadioListTile(
      //subtitle: Text("helllo"),
      title: Html(
        data: removeAllHtmlTags(answerText),

        defaultTextStyle: TextStyle(fontSize: 20.0),
        //useRichText: true,
        //backgroundColor: Colors.red,

        //style: TextStyle(fontSize: 20),
      ),
      //activeColor: Colors.red,
      groupValue: groupValue,
      value: id,
      onChanged: (id) {
        return explanation ? null : appState.answerCheck(id);
      },
    );
  }
}
