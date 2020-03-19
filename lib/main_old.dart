import 'package:flutter/material.dart';
import 'app_state.dart';
import 'package:provider/provider.dart';
import './model/dev_config.dart';
import './model/app_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DevConfig.init(); // fetch home dir path on app start-> do not remove
  await onAppBoot(); //init sqflite database and other stuff
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Counter(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<Counter>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              appState.counter.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var a = {"user_guid": "04hbA"};
          var retRecord = await runApi("cat2.user2_get", a);
          //var c = (await loadQuestion(contentGuid: "004Ue"));
          print(retRecord);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
