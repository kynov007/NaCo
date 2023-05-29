import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_sampah/query_helper.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'calculator_app.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    String path = await getDirectoryPath(_databaseName);
    if (kDebugMode) {
      print('Database initializing');
    }
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future<String> getDirectoryPath(String fileName) async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path = join(dataDirectory.path, fileName);
    return path;
  }

  Future _onCreateDB(Database db, int version) async {
    if (kDebugMode) {
      print('DB Created');
    }

    await db.execute(QueryHelper.createTabelSampah).then((value) {
      if (kDebugMode) {
        print('[database helper] Table sampah created successfully...');
      }
    });

    await db.execute(QueryHelper.createTableNotifikasi).then((value) {
      if (kDebugMode) {
        print('[database helper] Table Notifikasi created successfully...');
      }
    });

    await db.execute(QueryHelper.createTabelNotifHistory).then((value) {
      if (kDebugMode) {
        print('[database helper] Table Notifi History created successfully...');
      }
    });
  }

  Future insertSingleData({required String queryAndData}) async {
    Database? db = await instance.database;
    var batch = db?.batch();
    batch?.rawInsert(queryAndData);
    await batch?.commit(noResult: true);
  }

  Future insertData(List queryAndData) async {
    // Future insertData(String tableName, List data) async {
    // Future insertData(String query, Map<String, dynamic> data) async {
    Database? db = await instance.database;
    // await db?.transaction((txn) async {
    //   txn.execute(query, data);
    // });

    // await db?.transaction((txn) async {
    //   var _db = txn.batch();
    var batch = db?.batch();
    for (int i = 0; i < queryAndData.length; i++) {
      // batch?.insert(query, data[i]);
      batch?.rawInsert(queryAndData[i]);
    }
    await batch?.commit(noResult: true);
    // await db?.insert(query, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Future loadAllData(String tableName, String query) async {
  Future loadAllData(String query) async {
    Database? db = await instance.database;
    // return await db?.query(tableName);
    return await db?.rawQuery(query);
    db?.close();
  }

  // Future deleteData(String tableName) async {
  //   Database? db = await instance.database;
  //   await db?.transaction((txn) async {
  //     txn.execute(QueryHelper().deleteTableQuery(tableName));
  //   });
  // }

  Future execQuery(String query) async {
    print('[database_helper] on execQuery');
    Database? db = await instance.database;
    await db?.transaction((txn) async {
      await txn.execute(query);
    });
  }
}
