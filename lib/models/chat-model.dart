import 'package:firebase_database/firebase_database.dart';

class Chat {
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

  toJson() {
    return {
      "userId": userId,
      "message": message,
      "dateTime": dateTime.toString(),
    };
  }
}
