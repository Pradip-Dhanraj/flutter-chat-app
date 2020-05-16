import 'package:chat/services/auth-services.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Auth auth;

  Dashboard({@required this.auth});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
