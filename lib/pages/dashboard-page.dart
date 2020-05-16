import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Auth auth;
  final MessagingManger messagecenter;

  Dashboard({@required this.auth, @required this.messagecenter});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.messagecenter.createChatDb(),
        builder: (_context, _builder) {
          return Container();
        },
      ),
    );
  }
}
