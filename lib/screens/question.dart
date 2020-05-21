import 'package:flutter/material.dart';
//import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:prepengine_new/flutter_html/flutter_html.dart';
import 'package:prepengine_new/flutter_html/style.dart';
//import 'package:html/dom.dart' as dom;

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  Widget build(BuildContext context) {
    //var document = parse(questionText);
    //print("output: " + document.outerHtml);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10.0),
      child: Html(data: questionText, style: {
        "*": Style(
          fontSize: FontSize(20.0),
        ),
      }),
      //webView: true,
    );
  }
}
