import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_provider.dart';
import 'package:provider/provider.dart';
import '../screens/quiz.dart';
import '../screens/result.dart';

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
    final setAns = appState.setAns;
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
              //print(groupValue);

              if (setAns == false) {
                appState.setAnswer();
              }
            } else {
              appState.getNextQuestion();
              appState.avoidFirstClick();
            }
          },
          tooltip: 'Next',
          child: new Icon(Icons.navigate_next),
        ),
      ),
      appBar: AppBar(
          //title: Text("PrepEngine"),
          backgroundColor: Color(int.parse(color)),
          leading: new IconButton(
              icon: new Icon(Icons.dehaze),
              onPressed: () {
                appState.getResult();
                //appState.getResultfetch();
                globalKey.currentState.openDrawer();
              }),
          //: Container(),
          actions: <Widget>[
            ...(lastResult).map((answer) {
              //print(answer);
              return showLastAttempts(answer);
            }).toList(),
            new Visibility(
              visible: stop_button,
              child: IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, '/');
                  //appState.stopQuiz();
                  showAlertDialog(context, appState);
                },
              ),
            )
          ]),
      body: PageView.builder(
        itemCount: null,
        physics: CustomScrollPhysics(),
        onPageChanged: (i) {
          if (groupValue != "") {
            if (firstClick == false) {
              appState.showExplanation();
              appState.setClick();
              if (setAns == false) {
                appState.setAnswer();
              }
            } else {
              appState.getNextQuestion();
              appState.avoidFirstClick();
            }
          }
        },
        //onPageChanged: ,
        itemBuilder: (context, position) {
          return isStart < 2 ? Quiz() : Result();
        },
      ),
    );
  }
}

showAlertDialog(BuildContext context, appState) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Exit"),
    content: Text("Are you sure to exit?"),
    actions: <Widget>[
      FlatButton(
        child: Text('Yes'),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
          appState.stopQuiz();
        },
      ),
      FlatButton(
        child: Text('No'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: Icon(icon),
          onTap: () {
            null;
          },
        ),
      ),
    );
  }
}

class drawerData extends StatelessWidget {
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
                Text(removeHour(totalTime))
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  bool isGoingLeft = false;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingLeft = offset.sign < 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    //print("applyBoundaryConditions");
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent)
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value)
      // overscroll
      return value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge

      return value - position.minScrollExtent;

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;

    if (!isGoingLeft) {
      return value - position.pixels;
    }
    return 0.0;
  }
}
