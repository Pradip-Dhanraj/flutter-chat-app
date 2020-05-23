import 'dart:async';

import 'package:chat/helper/app-helper-functions.dart';
import 'package:chat/helper/app-routes.dart';
import 'package:chat/helper/app-strings.dart';
import 'package:chat/helper/app-theme.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/models/local-database.dart' as local;
import 'package:chat/pages/dashboard-page.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:chat/services/local-database-services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'base-page.dart';
import 'contact-page.dart';
import 'profile-page.dart';

class ChatList extends StatefulWidget {
  final Auth auth;
  final BaseFirebaseDatabase firebaseDatabase;
  final String userid;
  ChatList({
    @required this.auth,
    @required this.firebaseDatabase,
    @required this.userid,
  });
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  //List<local.BaseLocalModel> dataList;
  @override
  void initState() {
    //dataList = List<local.Chat>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> gets() async {
    //var lst = [];
    var dd = await getLocalDB()
        .getChatList(dbTable: AppStrings.localChatDatabaseTable);
    // for (var chat in dd) {
    //   setState(() {
    //     lst.add(chat);
    //   });
    // }
    return dd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: getDrawer(
      //   context: context,
      //   userid: widget.userid,
      // ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: chambray,
          child: Icon(
            Icons.contacts,
            color: wattle,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              ApllicationRoutes.routeToContacts,
              arguments: ContactList(
                auth: widget.auth,
                firebaseDatabase: widget.firebaseDatabase,
                userid: widget.userid,
              ),
            );
          }),
      appBar: getAppBarUpdated(
        "Chat List",
        context,
        widget.userid,
        profileArguments: ProfilePage(
          auth: widget.auth,
          firebaseDatabase: widget.firebaseDatabase,
          userid: widget.userid,
        ),
      ),
      body: FutureBuilder(
        future: getLocalDB()
            .getChatList(dbTable: AppStrings.localChatDatabaseTable),
        builder: (_buildContext, snapshot) {
          var dataList = snapshot.data;
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (_context, i) {
                    var data = (dataList[i] as local.Chat);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ApllicationRoutes.routeToDashboard,
                              arguments: ChatBoard(
                                auth: widget.auth,
                                firebaseDatabase: widget.firebaseDatabase,
                                userid: widget.userid,
                                chatid: data.uniqueid,
                                displayName: data.displayname,
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Text(
                              data?.displayname,
                              textAlign: TextAlign.center,
                            ),
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
