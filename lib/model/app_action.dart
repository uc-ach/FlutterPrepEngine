/*
 * File Name   : app_action.dart
 * Author      : Akshay Pauranik
 * Function    : Library of Commonly used functions in the app having business logic
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/

library app_action;

import 'dart:convert';

import 'package:flutter/material.dart';

import './dev_config.dart';
import './theme_action.dart';
import 'package:http/http.dart' as http;
import './db_schema.dart';
import './db_operations.dart' as UCDB;

String _apiAccessToken = '';

Future<String> getApiAuthToken({checkExpired: false}) async {
  var client = UC.client;
  var postObj = {'email': client['email']};
  if (checkExpired) {
    postObj['action'] = _apiAccessToken;
    postObj['refresh_token'] = '1';
  }
  if (client['isSocial']) {
    postObj['social_login'] = '1';
  }
  var devId = DevConfig.getDeviceInfo(valueOf: 'device_id');
  postObj['device_id'] = devId;
  var url = '${DevConfig.REMOTE_API_URL}?func=cat2.authenticate';

  var response = await http.post(Uri.encodeFull(url), body: postObj);

  if (response.statusCode == 200) {
    RegExp reg = new RegExp(r"<jsonstring>(.*?)<\/jsonstring>");
    var json = reg.firstMatch(response.body).group(1);
    var parsedJSON = DartJson(json);
    _apiAccessToken = (parsedJSON.read('access_token').raw());
  }
  return _apiAccessToken;
}

Future<Map<String, dynamic>> runApi(
    String apiName, Map<String, String> postData) async {
  var url = '${DevConfig.REMOTE_API_URL}?func=${apiName}';
  if (_apiAccessToken.isEmpty) {
    print('A');
    await getApiAuthToken();
  }
  var response = await http
      .post(url, body: postData, headers: {'access-token': _apiAccessToken});
  if (response.statusCode == 200) {
    RegExp reg = new RegExp(r"<jsonstring>(.*?)<\/jsonstring>");
    var json = reg.firstMatch(response.body).group(1);

    // var parsedJSON = DartJson(json);
    return jsonDecode(json);
  } else {
    return {'statusCode': response.statusCode};
  }
}

Future<Content> loadQuestion({@required String contentGuid}) async {
  var content = UCCache.content[contentGuid] ??
      (await UCDB.ContentTable.getContentByGuid(contentGuid));
  return content;
}

Future<void> handleLogin(String email, String password) async {
  // await API.getContentByGuid('002m3');

  // await UCDB.ContentTable.putAll([
  //   UCDB.ContentTable('abcde', 'q', 0, 0, 'naosdkjf', 'hello akshay how are you?')
  //       .toMap(),
  //   UCDB.ContentTable('abce', 'q', 0, 0, 'no no no no', 'hello akshay how are you?')
  //       .toMap()
  // ]);
  // var dt = (await UCDB.ContentTable.getContentByGuid('002m3'));
  // print(dt.getData.read('content.0'));
  // UC.pushScene('/welcome', isReplace: true);
  return;
  print(runApi('cat2.user_get', {'email': email}));
  print(email);
  print(password);
}

Future<void> onAppBoot() async {
  await UCDBSchema.db.initDB(DevConfig.HOME_PATH);
}
