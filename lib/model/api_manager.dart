/*
 * File Name   : api_manager.dart
 * Author      : Akshay Pauranik
 * Function    : All and only those functions which needs api interaction
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/

import './db_operations.dart';
import './app_action.dart';
import './theme_action.dart';

class API {
  API._();

  static Future<Content> getContentByGuid(String guid,
      {saveOffline: true}) async {
    var response = await runApi(UCAPI.fbContentSet, {
      'content_guid': guid,
      'full_data': '1',
      'isrealm': '1',
      'replace_answer': '0'
    });
    var respJson = DartJson(response);
    var content = respJson.read('content.0').raw();
    var mappedContent = Content.fromMap(content);
    if (saveOffline && content is Map) {
      ContentTable.put(content);
    }
    return mappedContent;
  }
}

class UCAPI {
  static const String fbContentSet = 'cat2.fb_content_set';
}
