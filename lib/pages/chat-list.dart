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

class _ChatListState extends State<ChatList> implements BasePage {
  @override
  List<BaseModel> dataList;

  @override
  Query dbQuery;

  @override
  StreamSubscription<Event> onDataAddedSubscription;

  @override
  StreamSubscription<Event> onDataChangedSubscription;
  @override
  void initState() {
    dataList = List<Profile>();
    dbQuery = widget.firebaseDatabase.getDatabaseQuery(
      dbName: AppStrings.profiledb,
    );
    onDataAddedSubscription = dbQuery.onChildAdded.listen(onEntryAdded);
    onDataChangedSubscription = dbQuery.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  onEntryChanged(Event event) {
    var oldEntry =
        dataList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      if (oldEntry != null)
        dataList[dataList.indexOf(oldEntry)] =
            Profile.fromSnapshot(event.snapshot);
    });
  }

  void updateChatList() {
    // var activeprofiles =
    //     dataList.where((user) => (user as Profile)?.userId == widget.userid);
    // List<ChatMapping> activechats = [];
    //  var _allchatmapping = widget.firebaseDatabase.getDatabaseQuery(
    //   dbName: AppStrings.chatdb,
    // );
  }

  onEntryAdded(Event event) {
    setState(() {
      dataList.add(Profile.fromSnapshot(event.snapshot));
      updateChatList();
    });
  }

  @override
  void dispose() {
    onDataChangedSubscription?.cancel();
    onDataAddedSubscription?.cancel();
    super.dispose();
  }

  String generateUniqueKey(String user1, String user2) {
    var uniquekey = "";
    var minlength = user1.length < user2.length ? user1.length : user2.length;
    for (var i = 0; i < minlength; i++) {
      var c1 = user1.codeUnitAt(i);
      var c2 = user2.codeUnitAt(i);
      if (c1 != c2) {
        uniquekey = (c1 > c2) ? "$user1$user2" : "$user2$user1";
        break;
      }
    }
    return uniquekey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(
        context: context,
        userid: widget.userid,
      ),
      appBar: getAppBarUpdated(
        "Contact List",
        context,
        widget.userid,
      ),
      body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (_context, i) {
            var data = (dataList[i] as Profile);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () {
                  var uniquekey = generateUniqueKey(data.userId, widget.userid);
                  var chatmapping = ChatMapping(uniquekey, [
                    Chat(
                      "Chat createtion",
                      widget.userid,
                      DateTime.now(),
                    )
                  ]);
                  widget.firebaseDatabase.pushData(
                    dbName: AppStrings.chatdb,
                    model: chatmapping,
                  );
                },
                child: SizedBox(
                  child: Text(
                    data?.username,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
