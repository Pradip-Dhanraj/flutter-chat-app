import 'dart:async';

import 'package:chat/models/chat-model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BasePage {
  Query dbQuery;
  List<BaseModel> dataList;
  StreamSubscription<Event> onDataAddedSubscription;
  StreamSubscription<Event> onDataChangedSubscription;
}
