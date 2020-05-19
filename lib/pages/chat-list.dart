import 'dart:async';

import 'package:chat/helper/app-helper-functions.dart';
import 'package:chat/helper/app-strings.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'base-page.dart';

class ChatList extends StatefulWidget {
  final Auth auth;
  final BaseFirebaseDatabase firebaseDatabase;
  final userid;
  ChatList({
    @required this.auth,
    @required this.firebaseDatabase,
    @required this.userid,
  });
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<BaseModel> dataList;

  @override
  void initState() {
    dataList = List<Profile>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(
        context: context,
        userid: widget.userid,
      ),
      appBar: getAppBarUpdated(
        "Chat List",
        context,
        widget.userid,
      ),
      body: FutureBuilder(
        future: widget.firebaseDatabase.getProfileData(),
        builder: (_buildContext, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (_context, i) {
                    var data = (dataList[i] as Profile);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          child: Text(
                            data?.username,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
