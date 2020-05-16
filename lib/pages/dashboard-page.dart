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
  final userid;

  ChatBoard({
    @required this.auth,
    @required this.firebaseDatabase,
    @required this.userid,
  });
  @override
  _ChatBoardState createState() => _ChatBoardState();
}

class _ChatBoardState extends State<ChatBoard> {
  Query _chats;
  List<Chat> _chatList;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  TextEditingController _inputController;
  ScrollController _chatController;
  @override
  void initState() {
    _inputController = TextEditingController();
    _chatController = ScrollController();
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
    _chatController.dispose();
    _inputController.dispose();
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
    //_chatController.po
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(
        context: context,
        userid: widget.userid,
      ),
      appBar: getAppBarUpdated("Dashboard", context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListView.builder(
              controller: _chatController,
              shrinkWrap: true,
              itemCount: _chatList.length,
              itemBuilder: (_context, i) {
                var c = _chatList[i];
                return Text(
                    "userid - ${c.userId}\ntime - ${c.dateTime} \nMessage - ${c.message}\n\n");
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _inputController,
                  ),
                ),
                RaisedButton(
                  child: Text("Add"),
                  onPressed: () {
                    if (_inputController.text == "") return;
                    var chat = Chat(
                      _inputController.text,
                      widget.userid,
                      DateTime.now(),
                    );
                    widget.firebaseDatabase.pushData(
                      dbName: AppStrings.chatdb,
                      model: chat,
                    );
                    _inputController.text = "";
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
