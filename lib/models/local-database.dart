abstract class BaseLocalModel {
  Map<String, dynamic> toMap();
}

class Chat implements BaseLocalModel {
  final String displayname;
  final String time;
  final String uniqueid;

  Chat({this.time, this.displayname, this.uniqueid});

  @override
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'displayname': displayname,
      'uniqueid': uniqueid,
    };
  }
}
