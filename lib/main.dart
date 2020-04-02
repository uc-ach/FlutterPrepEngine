import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_provider.dart';
import 'package:provider/provider.dart';
import './model/dev_config.dart';
import './model/app_action.dart';
import './screens/second_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DevConfig.init(); // fetch home dir path on app start-> do not remove
  await onAppBoot(); //init sqflite database and other stuff
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => StartQuiz(),
          '/second_page': (context) => MyHome(),
        },
        //home: MyHome(),
      ),
    );
  }
}

class StartQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String color = "0xff168483";
    final appState = Provider.of<AppState>(context);
    //final nextQues = appState.nextQues;
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text("PrepEngine"),
          backgroundColor: Color(int.parse(color)),
        ),
        body: SingleChildScrollView(
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
                      Navigator.pushReplacementNamed(context, '/second_page');
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
        )));
  }
}
