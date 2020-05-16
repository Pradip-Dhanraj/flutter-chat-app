import 'package:firebase_database/firebase_database.dart';

abstract class BaseModel {
  toJson();
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
