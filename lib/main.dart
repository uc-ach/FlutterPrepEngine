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
            firstScreen(),
            new Container(
              padding: new EdgeInsets.only(top: 16.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.play_circle_outline,
                        size: 150, color: Colors.blueGrey),
                    //iconSize: 150.0,
                    //color: Colors.red,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/second_page');
                      appState.getTestSessionId();
                      //staQuiz();
                    },
                    //color: Colors.blue,
                  ),
                ],
              ),
            ),
            //new Text('Start Quiz',
            //  style: new TextStyle(
            //    fontSize: 35.0,
            //  fontFamily: 'Roboto',
            //color: new Color(0xFF26C6DA))),
            Container(
              padding: new EdgeInsets.only(top: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Get an item correct each time in 3 consecutive attempts to "master" it. Your Goal is to master all items.',
                        textAlign: TextAlign.center),
                  ]),
            ),
            Container(
              padding: new EdgeInsets.only(top: 10.0),
              child: Text("You can stop at any time and continue later."),
            )
          ],
        )));
  }
}

class firstScreen extends StatelessWidget {
  String removeHour(String htmlText) {
    RegExp exp = RegExp(r"hours|hour", multiLine: true, caseSensitive: true);
    RegExp min =
        RegExp(r"minutes|minute", multiLine: true, caseSensitive: true);
    htmlText = htmlText.replaceAll(exp, 'h');
    return htmlText.replaceAll(min, 'm');
  }

  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //final fetchStat = appState.fetchStat;
    final masteredItems = appState.masteredItems;
    final totalTime = appState.totalTime;
    final getResult = appState.getResult;
    final masteredItemsPerc = appState.masteredItemsPerc;
    final inPlay = appState.inPlay;
    final inPlayPerc = appState.inPlayPerc;
    final pendingItems = appState.pendingItems;
    final pendingItemsPerc = appState.pendingItemsPerc;
    final showDraw = appState.showDraw;
    getResult();
    return showDraw
        ? Container(
            padding: EdgeInsets.all(20.00),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(children: <Widget>[
                      Icon(Icons.check_circle, color: Colors.green, size: 40.0),
                      Text("Mastered",
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      Text(masteredItems + "(" + masteredItemsPerc + "%)")
                    ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(children: <Widget>[
                      Icon(Icons.play_circle_filled,
                          color: Colors.orange, size: 40.0),
                      Text("In Play",
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      Text(inPlay + "(" + inPlayPerc + "%)")
                    ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(children: <Widget>[
                      Icon(CupertinoIcons.ellipsis,
                          color: Colors.red, size: 40.0),
                      Text("Pending",
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      Text(pendingItems + "(" + pendingItemsPerc + "%)")
                    ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(children: <Widget>[
                      Icon(
                        CupertinoIcons.time_solid,
                        color: Colors.blueAccent,
                        size: 40.0,
                      ),
                      Text("Time",
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      Text(removeHour(totalTime))
                    ]),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
