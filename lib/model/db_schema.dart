/*
 * File Name   : db_schema.dart
 * Author      : Akshay Pauranik
 * Function    : Database(sqflite) schema file
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UCDBSchema {
  UCDBSchema._();
  static final UCDBSchema db = UCDBSchema._();
  static Database _database;

  Database get instance {
    return _database;
  }

  Future<void> initDB(String homePath) async {
    String path = join(homePath, "UCDB.db");
    await openDatabase(path, version: 1, onOpen: (db) {
      _database = db;
    }, onCreate: (Database _db, int version) async {
      await _db.execute("""
                CREATE TABLE Content (
               content_guid TEXT PRIMARY KEY,
               content_type TEXT,
               content_subtype INTEGER DEFAULT 0,
               content_icon INTEGER DEFAULT 0,
               snippet TEXT,
               content_text TEXT);

               CREATE TABLE UserData (
               user_guid TEXT PRIMARY KEY,
               user_data TEXT,
               );
               """);
    });
  }
}
