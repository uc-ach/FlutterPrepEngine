/*
 * File Name   : db_operations.dart
 * Author      : Akshay Pauranik
 * Function    : All database interaction are done only in this file
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/

import 'package:sqflite/sqflite.dart';
import './db_schema.dart';
import './theme_action.dart';
import 'api_manager.dart';

/// Content Table Schema
class ContentTable {
  static const _tableName = 'Content';

  ///Required for bulk data type conversion
  static Map<String, dynamic> _convertItemTypes(Map<String, dynamic> items) {
    items.forEach((key, value) {
      if (items[key] is! int &&
          (key == 'content_subtype' || key == 'content_icon')) {
        items[key] = $(value).toInt();
      } else if (items[key] is! String) {
        items[key] = value.toString();
      }
    });
    return items;
  }

  static putAll(List<Map<String, dynamic>> records) async {
    Batch batch = UCDBSchema.db.instance.batch();
    for (var item in records) {
      var safeItem = ContentTable._convertItemTypes(item);
      batch.insert(_tableName, safeItem,
          conflictAlgorithm: ConflictAlgorithm
              .replace); //overwrite record if key already exists else insert new record
    }
    await batch.commit(noResult: true);
  }

  static put(Map<String, dynamic> record) async {
    await UCDBSchema.db.instance.insert(
        _tableName, ContentTable._convertItemTypes(record),
        conflictAlgorithm: ConflictAlgorithm
            .replace); //overwrite record if key already exists else insert new record
  }

  static Future<Content> getContentByGuid(String contentGuid) async {
    var record = await UCDBSchema.db.instance
        .query(_tableName, where: 'content_guid = ?', whereArgs: [contentGuid]);
    Content retRecord;
    if (record.length > 0) {
      retRecord = Content.fromMap(record[0]);
    } else {
      retRecord = await API.getContentByGuid(contentGuid);
    }
    return retRecord;
  }

  static Future<Map<String, Map<String, dynamic>>> getAllContentByGuid(
      List<String> contentGuid) async {
    var arrRecords = await UCDBSchema.db.instance.query(_tableName,
        where: 'content_guid IN (${contentGuid.map((_) => '?').join(', ')})',
        whereArgs: contentGuid);
    Map<String, Map<String, dynamic>> mappedObj = {};
    for (var item in arrRecords) {
      mappedObj[item['content_guid']] = item;
    }
    return mappedObj.length > 0 ? mappedObj : null;
  }
}

/// UserData Table Schema
class UserDataTable {
  static const _tableName = 'UserData';

  static getKey(uGuid) async {
    var data = await UCDBSchema.db.instance
        .query(_tableName, where: 'user_guid = ?', whereArgs: [uGuid]);
  }

  static put(Map record) async {
    await UCDBSchema.db.instance.insert(_tableName, record,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
