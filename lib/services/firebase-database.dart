import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/helper/app-strings.dart';
import 'package:chat/models/chat-model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth-services.dart';

abstract class BaseFirebase {
  Query getDatabaseQuery({String dbName});
  void pushData({String dbName, BaseModel model});
}

abstract class FirebaseWebService {
  Future<dynamic> getJsonData({
    @required String dbName,
  });
}

class BaseFirebaseDatabase implements BaseFirebase, FirebaseWebService {
  String baseUrl = "https://flutter-chat-app-cb9b8.firebaseio.com/";
  Query getDatabaseQuery({String dbName}) =>
      FirebaseDatabase.instance.reference().child(dbName).orderByKey();
  void pushData({String dbName, BaseModel model}) async {
    FirebaseDatabase.instance
        .reference()
        .child(dbName)
        .push()
        .set(model.toJson());
  }

  void pushDataWithKey({
    String dbName,
    BaseModel model,
    String key,
  }) async {
    FirebaseDatabase.instance
        .reference()
        .child(dbName)
        .child(key)
        .set(model.toJson());
  }

  @override
  Future<dynamic> getJsonData({String dbName}) async {
    var response = await http.get(
        "https://flutter-chat-app-cb9b8.firebaseio.com/$dbName.json?auth=$dbTokenid");
    if (response.statusCode != 200)
      return null;
    else
      return response.body;
    // var response = await http
    //     .get(
    //       "https://flutter-chat-app-cb9b8.firebaseio.com/$dbName",
    //       headers: {HttpHeaders.authorizationHeader: dbTokenid},
    //     )
    //     .timeout(Duration(seconds: 5),
    //         onTimeout: () =>
    //             throw TimeoutException("Timeout exception on $dbName"))
    //     .catchError((){
    //        print("Error on $dbName");
    //     });
    // if (response.statusCode != 200)
    //   return null;
    // else
    //   return response.body;
  }

  Future<List<Profile>> getProfileData() async {
    var _json = await getJsonData(
      dbName: AppStrings.profiledb,
    );
    // return _json.map((v) => v.fromJson()).toList();
  }
}
