import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:chat/helper/app-helper-functions.dart';
import 'package:chat/helper/app-strings.dart';
import 'package:chat/helper/app-theme.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/models/local-database.dart' as local;
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:chat/services/local-database-services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatBoard extends StatefulWidget {
  final Auth auth;
  final BaseFirebaseDatabase firebaseDatabase;
  final String userid;
  final String chatid;
  final String displayName;

  ChatBoard({
    @required this.auth,
    @required this.firebaseDatabase,
    @required this.userid,
    @required this.chatid,
    @required this.displayName,
  });
  @override
  _ChatBoardState createState() => _ChatBoardState();
}

class _ChatBoardState extends State<ChatBoard> {
  Query _chats;
  List<Chat> _chatList;
  StreamSubscription<Event> _onChatAddedSubscription;
  StreamSubscription<Event> _onChatChangedSubscription;
  TextEditingController _inputController;
  ScrollController _chatController;
  LocalDB db;
  @override
  void initState() {
    db = getLocalDB();
    _inputController = TextEditingController();
    _chatController = ScrollController();
    _chatList = List<Chat>();
    _chats = widget.firebaseDatabase.getDatabaseQuery(
      dbName: "database/${widget.chatid}",
    );
    _onChatAddedSubscription = _chats.onChildAdded.listen(onEntryAdded);
    _onChatChangedSubscription = _chats.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onChatChangedSubscription?.cancel();
    _onChatAddedSubscription?.cancel();
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
  }

  Widget _chatWidget(Chat chat, bool isMyMessage) {
    var amOrPM = chat.dateTime.hour > 12 ? "pm" : "am";
    var _time =
        '${(chat.dateTime.hour > 12 ? chat.dateTime.hour - 12 : chat.dateTime.hour)}.${chat.dateTime.minute} $amOrPM';
    return Bubble(
      margin: isMyMessage
          ? BubbleEdges.only(
              top: 10,
              right: 10,
              left: 50,
            )
          : BubbleEdges.only(
              top: 10,
              right: 50,
              left: 10,
            ),
      alignment: isMyMessage ? Alignment.topRight : Alignment.topLeft,
      // nipWidth: 30,
      // nipHeight: 10,
      color: isMyMessage ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white,
      nip: isMyMessage ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      child: Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text('${chat.message}'),
          Text(
            _time,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: getDrawer(
      //   context: context,
      //   userid: widget.userid,
      // ),
      backgroundColor: breakerbay,
      appBar: getAppBarUpdated(
        "Chat",
        context,
        widget.userid,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              child: ListView.builder(
                controller: _chatController,
                shrinkWrap: true,
                itemCount: _chatList.length,
                itemBuilder: (_context, i) {
                  var c = _chatList[i];
                  return _chatWidget(
                    c,
                    widget.userid == c.userId,
                  );
                  // return Text(
                  //     "userid - ${c.userId}\ntime - ${c.dateTime} \nMessage - ${c.message}\n\n");
                },
              ),
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
                  onPressed: () async {
                    if (_inputController.text == "") return;
                    var chat = Chat(
                      _inputController.text,
                      widget.userid,
                      DateTime.now(),
                    );
                    widget.firebaseDatabase.pushData(
                      dbName: "database/${widget.chatid}",
                      model: chat,
                    );
                    _inputController.text = "";
                    await db.putInLocalDb(
                      dbTable: AppStrings.localChatDatabaseTable,
                      localmodel: local.Chat(
                        time: "${DateTime.now()}",
                        displayname: widget.displayName,
                        uniqueid: widget.chatid,
                      ),
                    );
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
