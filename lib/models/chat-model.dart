import 'package:firebase_database/firebase_database.dart';

abstract class BaseModel {
  toJson();
  String key;
}

class ChatMapping implements BaseModel {
  @override
  String key;
  List<Chat> conversation;
  ChatMapping(this.conversation);
  ChatMapping.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        conversation = snapshot.value["conversation"]
            .map((v) => v.fromSnapshot())
            .toList();
  @override
  toJson() {
    return {
      "conversation": this.conversation.map((v) => v.toJson()).toList(),
    };
  }
}

class Profile implements BaseModel {
  @override
  String key;
  String username;
  String userId;
  Profile(this.username, this.userId);
  Profile.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        username = snapshot.value["username"];
  @override
  toJson() {
    return {
      "userId": userId,
      "username": username,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      json['userId'],
      json['username'],
    );
  }
}

class Chat implements BaseModel {
  String key;
  String message;
  DateTime dateTime;
  String userId;

  Chat(this.message, this.userId, this.dateTime);

  Chat.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        message = snapshot.value["message"],
        dateTime = DateTime.parse(snapshot.value["dateTime"]);

  @override
  toJson() {
    return {
      "userId": userId,
      "message": message,
      "dateTime": dateTime.toString(),
    };
  }
}
