import 'package:chat/models/chat-model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseFirebase {
  Query getDatabaseQuery({String dbName});
}

class BaseFirebaseDatabase implements BaseFirebase {
  Query getDatabaseQuery({String dbName}) =>
      FirebaseDatabase.instance.reference().child(dbName).orderByKey();
  void pushData({String dbName, BaseModel model}) async {
    FirebaseDatabase.instance
        .reference()
        .child(dbName)
        .push()
        .set(model.toJson());
  }
}
