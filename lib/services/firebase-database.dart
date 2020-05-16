import 'package:firebase_database/firebase_database.dart';

abstract class BaseFirebase {
  Query getDataReference({String dbName});
}

class BaseFirebaseDatabase implements BaseFirebase {
  Query getDataReference({String dbName}) =>
      FirebaseDatabase.instance.reference().child(dbName).orderByKey();
}
