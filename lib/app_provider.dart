import 'package:flutter/material.dart';
import 'dart:convert';
//import './model/dev_config.dart';
import './model/app_action.dart';

class AppState with ChangeNotifier {
  String mastered_items;
  String mastered_items_percent;
  String in_play;
  String in_play_percent;
  String pending_items;
  String pending_items_percent;
  int _isStart = 0;
  bool stopButton = false;
  bool explanation = false;
  bool nextButton = false;
  bool first_click = false;
  bool _isFetching = false;
  bool _showData = false;
  String testSession = "";
  String last_content_guid = "";
  String groupValue;
  String correctAns;
  String last_attempt;
  String total_time;
  String random_seq;
  Map last_result = {"1": "-1", "2": "-1", "3": "-1"};
  var question;
  List list = [];
  int get isStart => _isStart;
  String get totalTime => total_time;
  String get masteredItems => mastered_items;
  String get masteredItemsPerc => mastered_items_percent;
  String get inPlay => in_play;
  String get inPlayPerc => in_play_percent;
  String get pendingItems => pending_items;
  String get pendingItemsPerc => pending_items_percent;
  bool get fetchStat => _isFetching;
  String get lastAttempt => last_attempt;
  List get lastResult {
    list = [];
    last_result.forEach((k, v) => list.add(v));
    return list;
  }

  String get getGroupVal => groupValue;
  bool get isExplanation => explanation;
  bool get isNextButton => nextButton;
  bool get isStop => stopButton;
  bool get getClick => first_click;
  String get getTestSession => testSession;
  String get getCorrectAnswer => correctAns;
  String get lastContentGuid => last_content_guid;
  String get getLastItem => last_attempt;
  bool get showDraw => _showData;
  void setClick() {
    nextButton = true;
    notifyListeners();
  }

  void answerCheck(String e) {
    //isvisible = true;
    if (e == "A") {
      groupValue = "A";
    } else if (e == "B") {
      groupValue = "B";
    } else if (e == "C") {
      groupValue = "C";
    } else if (e == "D") {
      groupValue = "D";
    }
    nextButton = true;
    notifyListeners();
  }

  void showExplanation() {
    explanation = true;
    first_click = true;
    notifyListeners();
  }

  get getQuestion => question;
  void startQuiz() {
    _isStart = 1;
    groupValue = "";
    explanation = false;
    stopButton = true;
    nextButton = false;
    first_click = false;
    notifyListeners();
  }

  void stopQuiz() {
    _isStart = 0;
    groupValue = "";
    explanation = false;
    stopButton = false;
    nextButton = false;
    first_click = false;
    question = "";
    notifyListeners();
  }

  void getResultfetch() {
    //_isFetching = false;
    _showData = true;
    notifyListeners();
  }

  void getTestSessionId() async {
    var awhere = {
      "course_code": "03pOc",
      "user_guid": "04hbA",
      "can_pause": "1",
      "test_mode": "0",
      "show_time": "0",
      "passing_score": "700",
      "remove_when": "3",
      "part_guids": "",
      "chapter_available_questions": """{
        "03pOg": "8",
        "03pOH": "15",
        "03pOh": "6",
        "03pOI": "10",
        "03pOi": "10",
        "03pOJ": "10",
        "03pOj": "13",
        "03pOK": "9",
        "03pOk": "11",
        "03pOL": "9",
        "03pOl": "7",
        "03pOM": "8",
        "03pOm": "9",
        "03pON": "5",
        "0481w": ""
      }""",
      "chapters": """{
        "03pOg": "1 Introduction to JavaScript",
        "03pOH": "2 Working with Variables and Data in JavaScript",
        "03pOh": "3 Functions, Methods and Events in JavaScript",
        "03pOI": "4 Debugging and Troubleshooting JavaScript",
        "03pOi": "5 Controlling Program Flow in JavaScript",
        "03pOJ": "6 The JavaScript Document Object Model (DOM)",
        "03pOj": "7 JavaScript Language Objects",
        "03pOK": "8 Custom JavaScript Objects",
        "03pOk": "9 Changing HTML on the Fly",
        "03pOL": "10 Developing Interactive Forms with JavaScript",
        "03pOl": "11 JavaScript Security",
        "03pOM": "12 JavaScript Libraries and Frameworks",
        "03pOm": "13 JavaScript and AJAX",
        "03pON": "14 Introduction to Web APIs",
        "0481w": "15 Appendix"
      }"""
    };
    //print(awhere);
    var retRecord = await runApi("cat2.deliveryengine_quiz_create", awhere);
    if (retRecord.isNotEmpty) {
      //Map<String, dynamic> json = jsonDecode(retRecord);
      //print(retRecord['response']['test_session_id']);
      testSession = retRecord['response']['test_session_id'];
      getNextQuestion();
    }
    //print(retRecord);
  }

  void getNextQuestion() async {
    var where = {
      "user_guid": "04hbA",
      "course_code": "03pOc",
      "test_session_id": testSession,
      "last_content_guid": last_content_guid,
      "full_data": "1",
      "test_mode": "0"
    };
    print("Test Session : " + testSession);
    print("Content Guid : " + last_content_guid);
    var next_ques = await runApi("cat2.deliveryengine_quiz_item_next", where);
    question = next_ques['response'];
    last_content_guid = question['content_guid'];
    random_seq = question['random_seq'];
    print("random : " + random_seq);
    //print(question["result_points_2"]);
    for (var sName in question['answers']) {
      print(sName);
      if (sName['is_correct'] == "1") {
        correctAns = sName['seq_str'];
      }
    }
    last_attempt = "1";
    //var last_result = {};
    last_result["1"] = question['result_points_f'];
    last_result["2"] = question['result_points_2'];
    last_result["3"] = question['result_points_1'];

    if (int.parse(question['result_points_2']) > -1) {
      last_attempt = "2";
    }
    if (int.parse(question['result_points_1']) > -1) {
      //f first : -1, unattempted,
      //2 2 : 0 : attempted & wrong
      // 1 : attmpted & right
      // cr count 3 mastered

      last_attempt = "3";
    }
    if (int.parse(question['result_points_0']) > -1) {
      last_attempt = "3";
      last_result["1"] = question['result_points_2'];
      last_result["2"] = question['result_points_1'];
      last_result["3"] = question['result_points_0'];
    }
    //print(last_attempt);
    print("last content guid : " + last_content_guid);
    getResult();
    startQuiz();
    //print(last_content_guid);
  }

  void setAnswer() async {
    var where = {
      "user_guid": "04hbA",
      "course_code": "03pOc",
      "test_session_id": testSession,
      "content_guid": last_content_guid,
      "answer": groupValue,
      "time_spent": "1",
      "random_seq": random_seq,
      "userans": groupValue,
      "timespent": "1"
    };
    print(where);
    var result = await runApi("cat2.deliveryengine_quiz_answer_set", where);
    print(result);
  }

  void getResult() async {
    _isFetching = true;
    var where_res = {
      "user_guid": "04hbA",
      "course_code": "03pOc",
      "full_data": "1",
    };
    var result = await runApi("cat2.deliveryengine_quiz_result", where_res);
    var res = result['response']['04hbA'];
    mastered_items = res['mastered_items'];
    print(result['response']['04hbA']);
    mastered_items_percent = res['mastered_items_percent'];
    in_play = res['in_play'];
    in_play_percent = res['in_play_percent'];
    pending_items = res['pending_items'];
    pending_items_percent = res['pending_items_percent'];
    total_time = res['total_time_spent_in_all_sessions'];
    _isFetching = false;
    getResultfetch();
    //getResultfetch();
    //print(result);
  }
}
