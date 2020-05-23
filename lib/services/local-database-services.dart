import 'package:chat/helper/app-strings.dart';
import 'package:chat/models/local-database.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  Future<Database> getDatabase() async => openDatabase(
        join(await getDatabasesPath(), AppStrings.localDatabase),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE ${AppStrings.localChatDatabaseTable}(uniqueid TXT PRIMARY KEY, displayname TEXT, time TEXT)",
          );
        },
        version: 1,
      );

  Future<List<Map<String, dynamic>>> getAllData({
    String dbTable,
  }) async {
    var _db = await getDatabase();
    return await _db.query(dbTable);
  }

  Future<List<Chat>> getChatList({
    String dbTable,
  }) async {
    var maps = await getAllData(dbTable: dbTable);
    return List.generate(maps.length, (i) {
      return Chat(
        time: maps[i]['time'],
        displayname: maps[i]['displayname'],
        uniqueid: maps[i]['uniqueid'],
      );
    });
  }

  Future<dynamic> putInLocalDb({
    @required String dbTable,
    @required BaseLocalModel localmodel,
  }) async {
    var _db = await getDatabase();
    return _db.insert(
      dbTable,
      localmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

LocalDB getLocalDB() => LocalDB();
//Future<Database> getDB() async=> await LocalDB().getDatabase();
