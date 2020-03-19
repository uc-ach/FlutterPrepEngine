import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_provider.dart';
import 'package:provider/provider.dart';
import './model/dev_config.dart';
import './model/app_action.dart';
import './screens/quiz.dart';
import './screens/result.dart';

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
        home: MyHome(),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final stop_button = appState.isStop;
    final isStart = appState.isStart;
    final nextButton = appState.nextButton;
    final firstClick = appState.getClick;
    final correctAns = appState.getCorrectAnswer;
    final groupValue = appState.groupValue;
    final lastResult = appState.lastResult;
    final fetchStat = appState.fetchStat;
    final masteredItems = appState.masteredItems;
    final masteredItemsPerc = appState.masteredItemsPerc;
    final inPlay = appState.inPlay;
    final inPlayPerc = appState.inPlayPerc;
    final pendingItems = appState.pendingItems;
    final pendingItemsPerc = appState.pendingItemsPerc;
    final showDraw = appState.showDraw;
    //print(lastResult);
    String color = "0xff168483";
    return Scaffold(
      key: globalKey,
      drawer: new Drawer(
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 90.0,
            child: DrawerHeader(
              child: Text('Result',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  )),
              //padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(int.parse(color)),
              ),
            ),
          ),
          showDraw ? drawerData() : Text('Loading Result...'),
        ],
      )),
      floatingActionButton: new Visibility(
        visible: nextButton,
        child: new FloatingActionButton(
          onPressed: () {
            if (firstClick == false) {
              appState.showExplanation();
              appState.setClick();
              if (groupValue == correctAns) {
                final snackBar =
                    SnackBar(content: Text('Yayyy!! Correct Answer'));
                globalKey.currentState.showSnackBar(snackBar);
              } else {
                final snackBar =
                    SnackBar(content: Text('Oops!! Incorrect Answer'));
                globalKey.currentState.showSnackBar(snackBar);
              }
              appState.setAnswer();
              print("First Click");
            } else {
              appState.getNextQuestion();
              print("Second Click");
            }
          },
          tooltip: 'Increment',
          child: new Icon(Icons.navigate_next),
        ),
      ),
      appBar: AppBar(
          title: Text("PrepEngine"),
          backgroundColor: Color(int.parse(color)),
          leading: new IconButton(
              icon: new Icon(Icons.dehaze),
              onPressed: () {
                appState.getResult();
                //appState.getResultfetch();
                globalKey.currentState.openDrawer();
              }),
          actions: <Widget>[
            ...(lastResult).map((answer) {
              print(answer);
              return showLastAttempts(answer);
            }).toList(),
            new Visibility(
              visible: stop_button,
              child: IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  appState.stopQuiz();
                },
              ),
            )
          ]),
      body: isStart < 2 ? Quiz() : Result(),
    );
  }
}

class showLastAttempts extends StatelessWidget {
  String firstIndex;
  //String secondIndex;
  showLastAttempts(this.firstIndex);
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final stop_button = appState.isStop;
    var icon;
    if (int.parse(firstIndex) == -1) {
      icon = CupertinoIcons.circle;
    } else if (int.parse(firstIndex) == 0) {
      icon = CupertinoIcons.clear_circled;
    } else if (int.parse(firstIndex) == 1) {
      icon = CupertinoIcons.check_mark_circled;
    }
    ;
    return new Visibility(
      visible: stop_button,
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          null;
        },
      ),
    );
  }
}

class drawerData extends StatelessWidget {
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //final fetchStat = appState.fetchStat;
    final masteredItems = appState.masteredItems;
    final totalTime = appState.totalTime;
    final masteredItemsPerc = appState.masteredItemsPerc;
    final inPlay = appState.inPlay;
    final inPlayPerc = appState.inPlayPerc;
    final pendingItems = appState.pendingItems;
    final pendingItemsPerc = appState.pendingItemsPerc;
    return Container(
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
                Icon(CupertinoIcons.ellipsis, color: Colors.red, size: 40.0),
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
                Text("Time", style: new TextStyle(fontWeight: FontWeight.bold)),
                Text(totalTime)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
