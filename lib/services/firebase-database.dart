import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class MessagingManger {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query _todoQuery;
  DatabaseReference db;

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Future<void> createChatDb() {
    db = _database.reference().child("chatdb");
    //db.;
  }
}
