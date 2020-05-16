import 'dart:async';

import 'package:chat/helper/app-helper-functions.dart';
import 'package:chat/helper/app-strings.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatBoard extends StatefulWidget {
  final Auth auth;
  final BaseFirebaseDatabase firebaseDatabase;

  ChatBoard({@required this.auth, @required this.firebaseDatabase});
  @override
  _ChatBoardState createState() => _ChatBoardState();
}

class _ChatBoardState extends State<ChatBoard> {
  Query _chats;
  List<Chat> _chatList;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  @override
  void initState() {
    _chatList = List<Chat>();
    _chats =
        widget.firebaseDatabase.getDatabaseQuery(dbName: AppStrings.chatdb);
    _onTodoAddedSubscription = _chats.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription = _chats.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onTodoChangedSubscription?.cancel();
    _onTodoAddedSubscription?.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry =
        _chatList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      if (oldEntry != null)
        _chatList[_chatList.indexOf(oldEntry)] =
            Chat.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _chatList.add(Chat.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context: context),
      appBar: getAppBarUpdated("Dashboard", context),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _chatList.length,
              itemBuilder: (_context, i) {
                var c = _chatList[i];
                return Text(
                    "userid - ${c.userId}\ntime - ${c.dateTime} \nMessage - ${c.message}\n\n");
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              child: Text("Add"),
              onPressed: () {
                var chat = Chat("mobile msg", "99", DateTime.now());
                widget.firebaseDatabase.pushData(
                  dbName: AppStrings.chatdb,
                  model: chat,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
